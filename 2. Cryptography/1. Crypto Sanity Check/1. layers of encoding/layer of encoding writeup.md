# Crypto Sanity Check - Layers of encoding

**Author:** Senpai  

**Points:** 100

## Overview
This challenge involves peeling back three different layers of encoding to reveal the final message. 

## Solution

### Step 1: Decimal to ASCII
The initial string consists of space-separated decimal values. Converting them into ASCII text produces a hexadecimal string.

**Output:**
`55 30 73 74 51 30 56 53 56 48 74 73 4e 48 6b 7a 63 6a 4e 6b 58 32 78 70 61 7a 4e 66 4e 47 35 66 4d 47 35 70 4d 47 35 39`

### Step 2: Hexadecimal to ASCII
Decoding the resulting hex pairs into ASCII characters yields a Base64 encoded string.

**Output:**
`U0stQ0VSVHtsNHkzcjNkX2xpazNfNG5fMG5pMG59`

### Step 3: Base64 Decode
Finally, decoding the Base64 string uncovers the hidden message.

**Result:**
`SK-CERT{l4y3r3d_lik3_4n_0ni0n}`