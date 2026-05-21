# Crypto Sanity Check - x^y encryption
**Author:** Senpai  
**Points:** 100

## Overview
The challenge provides a hex-encoded ciphertext string and a Python script demonstrating how the plaintext was encrypted using a symmetric XOR function with a repeating hardcoded key.

## Encryption Analysis
Looking closely at `encryptor.py`, the cipher iterates through the flag and performs a bitwise XOR (`^`) against a cycling key:

```python
char_xor = ord(data[i]) ^ ord(key[i % len(key)])