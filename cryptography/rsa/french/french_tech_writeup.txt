# CTF Writeup: RSA Small Semi-Primes (Challenge 2)

**Category:** Cryptography  
**Flag:** `SK-CERT{f4c70r1ng_5m4ll_53m1_pr1m35_571ll_34sy_45_b3f0r3}`

---

## Overview

This challenge presents a textbook RSA encryption setup — but with two subtle weaknesses stacked on top of each other:

1. **The primes are too small** (192-bit), making the modulus factorable.
2. **The flag is longer than the modulus**, meaning RSA silently wrapped the message around modulo `n`.

Together, these two issues mean a standard decrypt gives you the *wrong* answer, and you need a bit of algebra to recover the real flag.

---

## The Challenge Files

**`main.py`** — the encryption script:
```python
from Crypto.Util.number import bytes_to_long, getPrime

flag = ""
m = bytes_to_long(flag.encode())
p = getPrime(192)
q = getPrime(192)
n = p * q
e = 65537
c = pow(m, e, n)
print("c: ", c)
print("n: ", n)
print("e: ", e)
```

**`out.txt`** — the public output:
```
c:  5740196029944570285461595789387642615026206835758048500685342416498085007060475130355254601538690350792607830802905
n:  17898028240830814136434787407852442663239728391134776310533753763258523791465145947321086853292608375964370070398263
e:  65537
```

---

## Step 1 — Understand the Setup (RSA Basics)

> **For newbies:** RSA encryption works like this:
> - Pick two large secret primes `p` and `q`
> - Compute `n = p * q` (the public modulus)
> - Encrypt: `c = m^e mod n`, where `m` is your message as a number
> - Decrypt: `m = c^d mod n`, where `d` is the private key derived from `p` and `q`
>
> Security depends on `n` being hard to factor. If you can find `p` and `q`, you can compute `d` and decrypt anything.

> **For the experienced:** Standard RSA-CRT or repeated squaring decryption. The private exponent is `d = e^(-1) mod φ(n)` where `φ(n) = (p-1)(q-1)`.

**Key observation:** `p` and `q` are 192-bit primes, making `n` only **384 bits (~115 decimal digits)**. Modern RSA uses 2048-bit or 4096-bit moduli. A 384-bit modulus is completely broken.

---

## Step 2 — Factor `n`

Because the primes are so small, `n` can be factored using existing databases and tools.

### Option A: FactorDB (easiest)

Go to [factordb.com](http://factordb.com) and paste `n`. It returns the factors immediately:

```
p = 3471990687824593680273251255463630853556792715805318789409
q = 5154975876978800665290208266910928152604080453168333003607
```

### Option B: Programmatic (Python + sympy)

```python
from sympy import factorint
n = 17898028240830814136434787407852442663239728391134776310533753763258523791465145947321086853292608375964370070398263
print(factorint(n))
```

> **Verify:** `p * q == n` ✓

---

## Step 3 — Attempt a Standard Decrypt

With `p` and `q` known, compute the private key and decrypt:

```python
from Crypto.Util.number import long_to_bytes

p = 3471990687824593680273251255463630853556792715805318789409
q = 5154975876978800665290208266910928152604080453168333003607
n = 17898028240830814136434787407852442663239728391134776310533753763258523791465145947321086853292608375964370070398263
e = 65537
c = 5740196029944570285461595789387642615026206835758048500685342416498085007060475130355254601538690350792607830802905

phi = (p - 1) * (q - 1)
d = pow(e, -1, phi)
m = pow(c, d, n)

print(long_to_bytes(m))
```

**Result:** Garbage bytes — not a valid flag.

> **Why?** The decryption is mathematically correct, but it only gives you `m mod n`. If the original `m` was *larger* than `n`, you've lost information.

---

## Step 4 — Recognize the Real Problem

This is where the challenge hint pays off: *"the flag may be longer than you expect."*

Let's count:
- `n` is a 384-bit number → **~48 bytes**
- A typical SK-CERT flag like `SK-CERT{f4c70r1ng_5m4ll_53m1_pr1m35_571ll_34sy_45_b3f0r3}` → **57 bytes**

**57 bytes > 48 bytes**, so when the script ran `c = pow(m, e, n)`, the message `m` was already larger than `n`. Python's `pow` silently computed `(m mod n)^e mod n` instead of `m^e mod n`.

> **For newbies:** Imagine trying to fit a 57-character message into a 48-character box by wrapping it around. You can decrypt perfectly and get back the wrapped version, but not the original — unless you know how many times it wrapped.

Mathematically:
```
m_real = m_recovered + k * n    (for some unknown integer k ≥ 1)
```

We need to find `k`.

---

## Step 5 — Recover the Flag Using Algebraic Constraints

We know the flag has the structure:
```
SK-CERT{ ... }
```

That gives us:
- A fixed **8-byte prefix**: `SK-CERT{`
- A fixed **1-byte suffix**: `}`
- All bytes in between are printable ASCII (values 32–126)

We can use this structure to solve for the middle directly — no brute force needed.

### The Math

For a flag of total length `L` bytes:

```
flag_int = prefix * 256^(L-8) + middle_int * 256 + ord('}')
```

Since `flag_int ≡ m_recovered (mod n)`:

```
middle_int * 256 ≡ m_recovered - prefix * 256^(L-8) - ord('}')  (mod n)
middle_int ≡ [m_recovered - prefix * 256^(L-8) - ord('}')] * modinv(256, n)  (mod n)
```

We then try each candidate length `L` and check if `middle_int` decoded to bytes is **all printable ASCII**.

### The Code

```python
n = 17898028240830814136434787407852442663239728391134776310533753763258523791465145947321086853292608375964370070398263
m = 13930258622482649586757211669016686392380080772860453103867664127598234167065873337163696622379201720501544364947868

prefix = int.from_bytes(b'SK-CERT{', 'big')
suffix  = ord('}')
inv256  = pow(256, -1, n)

for L in range(49, 120):           # total flag length in bytes
    mid_len = L - 9                # 8 prefix bytes + 1 suffix byte
    
    prefix_contrib = prefix * pow(256, L - 8, n) % n
    rhs            = (m - prefix_contrib - suffix) % n
    middle_int     = rhs * inv256 % n
    
    if middle_int >= 256 ** mid_len:
        continue                   # doesn't fit in mid_len bytes
    
    middle_bytes = middle_int.to_bytes(mid_len, 'big')
    
    if all(32 <= b <= 126 for b in middle_bytes):
        flag = b'SK-CERT{' + middle_bytes + b'}'
        print(flag.decode())
        # Verify
        assert int.from_bytes(flag, 'big') % n == m
```

**Output:**
```
SK-CERT{f4c70r1ng_5m4ll_53m1_pr1m35_571ll_34sy_45_b3f0r3}
```

---

## Summary of Vulnerabilities

| Vulnerability | Why It Matters |
|---|---|
| 192-bit primes | Far too small — modern tools factor them instantly. RSA requires 1024-bit primes minimum; 2048+ in practice. |
| Message larger than modulus | `bytes_to_long(flag)` was never checked against `n`. If `m ≥ n`, RSA silently encrypts `m mod n` instead, losing data. Always ensure `m < n` before encrypting. |

---

## Tools Used

- [factordb.com](http://factordb.com) — online factorization database
- Python 3 — `pow(e, -1, mod)` for modular inverse (built-in since Python 3.8)
- `pycryptodome` — `bytes_to_long` / `long_to_bytes`

---

## Flag

```
SK-CERT{f4c70r1ng_5m4ll_53m1_pr1m35_571ll_34sy_45_b3f0r3}
```

*"Factoring small semi-primes still easy as before"*
