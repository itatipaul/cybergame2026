import struct

with open('dump.mem', 'rb') as f:
    data = f.read()

dst_port = bytes([0xB8, 0xBB])
K = '5fg6r48v3aes5'

pos = 0
while True:
    pos = data.find(dst_port, pos)
    if pos == -1: break
    udp_start = pos - 2
    length_bytes = data[udp_start+4:udp_start+6]
    length = struct.unpack('!H', length_bytes)[0]
    if 8 < length < 200:
        payload = data[udp_start+8:udp_start+length]
        try:
            c = ''.join(chr(payload[i] ^ ord(K[i % len(K)])) for i in range(len(payload)))
            if all(32 <= ord(ch) < 127 for ch in c):
                print(f'{hex(pos)}: [{length} bytes] {c}')
        except:
            pass
    pos += 1
