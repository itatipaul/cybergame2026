# Miscrypto – Zippy Zip

Miscrypto – Zippy Zip (379 pts)

Category: Miscellaneous / Cryptography Tools: bkcrack
Description

    Someone encrypted this file, can you guess the password? I remember it contains something like -> flag is: SK-CERT{

We're given flag.zip, a password-protected zip file containing password.txt.
Analysis

Inspecting the zip reveals two critical details:

    Encryption: ZipCrypto (legacy zip encryption)
    Compression: STORE (no compression — raw bytes)
    File size: 53 bytes

The challenge hint tells us the plaintext starts with flag is: SK-CERT{ — 17 bytes of known plaintext. ZipCrypto with a known plaintext is vulnerable to the Biham & Kocher known-plaintext attack (KPA), which recovers the three internal 32-bit keys without needing the password.
Solution

Step 1: Build bkcrack from source (not in apt):
bash

git clone https://github.com/kimci86/bkcrack.git
cd bkcrack
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
sudo cp build/src/cli/bkcrack /usr/local/bin/

Step 2: Create the known plaintext file (no newline):
bash

echo -n "flag is: SK-CERT{" > plain.txt

Step 3: Run the KPA attack:
bash

bkcrack -C flag.zip -c password.txt -p plain.txt

After ~16 minutes, bkcrack recovers the internal keys:

Keys: 4cd3cc7f bd8a9331 e7ea787f

Step 4: Decrypt the file using the recovered keys:
bash

bkcrack -C flag.zip -c password.txt -k 4cd3cc7f bd8a9331 e7ea787f -d decrypted.txt
cat decrypted.txt

Flag

SK-CERT{...}

Key Takeaway

ZipCrypto (the default encryption in old zip tools) is fundamentally broken against known-plaintext attacks. If an attacker knows as little as 12 bytes of the plaintext, they can recover the internal keys and decrypt the entire file — no password needed. Always use AES-256 encryption (zip -e --encrypt with a modern tool, or 7-Zip with AES-256).
