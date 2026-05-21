# Crypto Sanity Check - rotted
**Author:** Senpai  
**Points:** 100

## Overview
The challenge presents a ciphertext string that has been obfuscated using a Caesar cipher variant. The title "rotted" heavily implies a ROT encoding scheme.

## Analysis
CTF flags for this competition follow the format `SK-CERT{...}`. Comparing our ciphertext prefix to the expected plaintext prefix allows us to deduce the rotation shift value:

* `F` $\rightarrow$ `S` (Shift of 13)
* `X` $\rightarrow$ `K` (Shift of 13)

This confirms the cipher is **ROT13**. Because ROT13 splits the 26-letter English alphabet exactly in half, encrypting and decrypting use the exact same key/shift.

## Solution

### Method 1: CyberChef
1. Copy the ciphertext: `FX-PREG{flzz37evp_e0747v0a}`
2. Open CyberChef and place the text into the **Input** field.
3. Search for the **ROT13** operation and drag it into the **Recipe** panel.
4. The decrypted plaintext will render in the **Output** field.

### Method 2: Python One-Liner
You can also quickly decode this in a terminal using Python's built-in codecs library:

```python
import codecs
print(codecs.decode('FX-PREG{flzz37evp_e0747v0a}', 'rot_13'))