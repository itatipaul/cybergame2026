# Miscrypto – Encryption Enjoyer

Miscrypto – encryption enjoyer

Category: Reverse Engineering / Crypto
Points: 416

Challenge Description

An incident response team recovered a single file from a compromised server, but the attacker encrypted it before disconnecting. Your task is to recover the original file.

TL;DR

The provided file was not strongly encrypted, but instead protected using a 10-byte repeating XOR key.
After decrypting it, the output turned out to be a Windows PE executable.
That executable contained the real flag, hidden behind another XOR-based decryption routine.

Recovered Flag
SK-CERT{d3CRyp73D_5uCce55fulLy_W3LL_D0N3}
Initial Recon

We are given a ZIP archive containing a single file:

unzip encrypted.zip
ls

Output:

encrypted

The file had no extension, so the first step was to determine what kind of data it contained.

Step 1 — Identify Whether the File Is Truly Encrypted

A quick entropy or byte-pattern inspection is always useful when dealing with “encrypted” mystery blobs.

Checking the file
file encrypted
xxd encrypted | head

The file command doesn’t recognize it as a known format, but the hex dump shows noticeable repeated byte patterns.

That’s a major clue.

Why this matters

If a file is encrypted using something modern like:

AES
ChaCha20
properly implemented stream/block ciphers

…it usually looks very random.

But this file showed signs of:

repetition
structure
suspicious regularity

That strongly suggests weak homemade encryption, and in CTFs that often means:

single-byte XOR
repeating-key XOR
substitution
rolling XOR
Step 2 — Suspecting Repeating-Key XOR

The byte repetition suggested that the encryption likely used a short repeating key.

Example of repeating-key XOR:

cipher[i] = plaintext[i] XOR key[i % key_length]

If the key is short, patterns from the plaintext “leak” into the ciphertext.

Step 3 — Recovering the XOR Key

There are several ways to recover a repeating XOR key:

Index of Coincidence
Hamming distance / normalized edit distance
known file signatures (magic bytes)
frequency analysis

In this case, the key length was found to be 10 bytes.

Recovered key
ab 31 b3 b2 b1 32 b4 b0 b9 32

Hex:

ab31b3b2b132b4b0b932
Step 4 — Decrypting the File

Once the key is known, decryption is straightforward.

Python decryptor
from pathlib import Path

data = Path("encrypted").read_bytes()
key = bytes.fromhex("ab31b3b2b132b4b0b932")

dec = bytes(b ^ key[i % len(key)] for i, b in enumerate(data))
Path("dec.exe").write_bytes(dec)

print("Decrypted file written to dec.exe")
Step 5 — Validate the Decrypted Output

Now let’s inspect the decrypted file.

file dec.exe
xxd dec.exe | head

Output begins with:

4d 5a ...

Which is:

MZ

That means the decrypted file is a Windows PE executable.

Why “MZ” matters

MZ is the standard magic header for Windows executables.

So the challenge wasn’t over yet — we had only peeled off the first layer.

Step 6 — Strings Analysis

Before jumping into disassembly, it’s always smart to run strings.

strings -n 5 dec.exe | less

A few very suspicious strings appeared:

o321039129031290329039021903129032190321903209132victim3291392312
xxx_victimXXXXXXXXX337

At first glance, these looked promising.

False Lead / Decoy

The string:

xxx_victimXXXXXXXXX337

looks like a possible flag template.

And the presence of strings such as:

victim

plus imports like:

GetUserNameA
gethostname

suggested the binary may build a flag dynamically based on the victim machine’s identity.

That is a very believable reverse engineering trap.

What this was trying to make us think

It tries to convince the solver that:

the username matters,
the machine hostname matters,
the weird number string contains some encoded suffix,
the final flag depends on runtime behavior.

That would send many people down a rabbit hole trying to decode:

o3210391290312903290...

But that was not the real solve path.

This was a decoy.

Step 7 — Reverse Engineering the PE

At this point, the right move is to actually inspect the binary in a disassembler / decompiler:

Ghidra
IDA
Binary Ninja
rizin / Cutter

I used the executable as a normal PE sample and started looking for:

main logic
string references
XOR loops
suspicious memory buffers
print/output functions
Step 8 — Locate the Real Decryption Routine

While analyzing the program flow, it becomes clear that the binary contains a small decryption routine that:

loads a buffer from .data
loads a short key from .rdata
XORs the buffer with the key in a loop
prints the decrypted result

That is the real flag recovery path.

Step 9 — Recover the Hidden Encrypted Flag

The encrypted flag blob lives in the PE’s .data section.

Relevant location
0x140003000

And the XOR key lives in .rdata around:

0x140004076
Recovered inner XOR key

Hex:

af 34 f0 10 99 20 01

So the binary is doing another repeating XOR, this time with a 7-byte key.

Step 10 — Extract the Inner Flag

Instead of fully emulating the binary, it’s easier to just extract the bytes manually and decrypt them.

Python script
from pathlib import Path

p = Path("dec.exe").read_bytes()

# Encrypted blob from .data
blob = bytearray(p[0x1e00:0x1e00 + 0x29])

# XOR key from .rdata
key = p[0x2076:0x2076 + 7]

for i in range(len(blob)):
    blob[i] ^= key[i % len(key)]

print(blob.decode())
Output
SK-CERT{d3CRyp73D_5uCce55fulLy_W3LL_D0N3}
Final Flag
SK-CERT{d3CRyp73D_5uCce55fulLy_W3LL_D0N3}
Full Solve Path Summary
Layer 1

The original mystery file was protected with repeating-key XOR.

Outer XOR key
ab31b3b2b132b4b0b932

Decryption revealed a Windows PE executable.

Layer 2

Inside that executable, another XOR routine was used to hide the real flag.

Inner XOR key
af34f010992001

That decrypted to:

SK-CERT{d3CRyp73D_5uCce55fulLy_W3LL_D0N3}
Why This Challenge Was Good

This challenge is a nice example of layered misdirection.

It combines:

weak crypto
file carving / format recognition
XOR recovery
basic malware-style reversing
reverse engineering traps / decoy strings

The challenge is especially good because it rewards people who don’t stop at:

“I decrypted the file, so I’m done.”

Instead, it makes you ask:

“What if the recovered file is itself hiding the real payload?”

That’s exactly the right mindset for both CTFs and real-world malware analysis.

Key Lessons
1) “Encrypted” does not always mean strong encryption

A lot of challenge authors — and malware authors — use:

XOR
rolling XOR
repeating XOR
byte shuffling

These are often enough to confuse casual inspection, but are not cryptographically secure.

2) Magic bytes are powerful

Known file signatures can instantly reveal whether a decryption guess is correct.

Examples:

MZ → PE executable
PK → ZIP
%PDF → PDF
\x89PNG → PNG

Once MZ appeared, that was a huge breakthrough.

3) Strings can lie

Those suspicious strings:

o321039129031290329039021903129032190321903209132victim3291392312
xxx_victimXXXXXXXXX337

looked important, but were mostly there to distract the solver.

That’s a classic reversing lesson:

Not every weird string is the answer.

Sometimes the shortest path is not to decode every string, but to understand the actual control flow.

4) Always inspect program logic

Once you open the PE in a decompiler and find:

a byte array
a short key
an XOR loop
a print function

…it’s usually game over.

Clean Reproduction Scripts
Outer Decryption
from pathlib import Path

data = Path("encrypted").read_bytes()
key = bytes.fromhex("ab31b3b2b132b4b0b932")

dec = bytes(b ^ key[i % len(key)] for i, b in enumerate(data))
Path("dec.exe").write_bytes(dec)

print("Recovered PE executable: dec.exe")
Inner Flag Extraction
from pathlib import Path

p = Path("dec.exe").read_bytes()

blob = bytearray(p[0x1e00:0x1e00 + 0x29])
key = p[0x2076:0x2076 + 7]

for i in range(len(blob)):
    blob[i] ^= key[i % len(key)]

print(blob.decode())
Conclusion

This challenge turned out to be a two-stage XOR puzzle disguised as an “incident response encrypted artifact.”

The attacker didn’t use real encryption at all — just:

one XOR layer to hide a PE
another XOR layer inside the PE to hide the flag

Once both layers were removed, the final answer was:

SK-CERT{d3CRyp73D_5uCce55fulLy_W3LL_D0N3}
