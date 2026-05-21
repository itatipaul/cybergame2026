import struct, re

with open('network.pcap', 'rb') as f:
    data = f.read()

# Parse all packets
offset = 24  # skip global PCAP header
packets = []
while offset < len(data) - 16:
    ts_sec, ts_usec, incl_len, orig_len = struct.unpack('<IIII', data[offset:offset+16])
    packets.append(data[offset+16:offset+16+incl_len])
    offset += 16 + incl_len

# Extract HTTP version from each request
versions = []
for pkt in packets:
    if len(pkt) < 40: continue
    ip = pkt[20:]  # skip 20-byte SLL2 header
    if len(ip) < 20 or (ip[0] >> 4) != 4: continue
    ihl = (ip[0] & 0xf) * 4
    if ip[9] != 6: continue   # TCP only
    tcp = ip[ihl:]
    if len(tcp) < 20: continue
    doff = (tcp[12] >> 4) * 4
    payload = tcp[doff:]
    if not payload: continue
    m = re.match(rb'(?:GET|POST|PUT|DELETE|PATCH) [^ ]+ HTTP/1\.([01])', payload)
    if m:
        versions.append(int(m.group(1)))

# Decode: 0 = bit 0, 1 = bit 1
bit_str = ''.join(str(v) for v in versions)
flag = bytes([int(bit_str[i:i+8], 2) for i in range(0, len(bit_str)-7, 8)])
print(flag.decode())
