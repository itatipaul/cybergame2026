def xor_decrypt(hex_data, key):
    # Convert hex string back into bytes
    data = bytes.fromhex(hex_data)
    plain_output = []
    
    for i in range(len(data)):
        # XOR each byte with the repeating key
        char_xor = data[i] ^ ord(key[i % len(key)])
        plain_output.append(chr(char_xor))
        
    return "".join(plain_output)

HARDCODED_KEY = "cybergame"
ciphertext = "30324f263735351656570a1b3a45573e1f56154a101641381605560d261b5507380959135026550d41380a5e1c1e"

print(xor_decrypt(ciphertext, HARDCODED_KEY))