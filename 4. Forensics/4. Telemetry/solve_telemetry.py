import struct
import matplotlib.pyplot as plt

def solve_telemetry(file_path):
    # 1. Parse Binary MAVLink 2.0 Packets
    positions = []
    with open(file_path, 'rb') as f:
        data = f.read()
    
    i = 0
    while i < len(data):
        if data[i] == 0xfd:  # MAVLink 2 Start Byte
            if i + 9 >= len(data): break
            payload_len = data[i+1]
            msg_id = struct.unpack('<I', data[i+7:i+10] + b'\x00')[0]
            
            # Header(10) + Payload + Checksum(2) + Optional Signature(13)
            sig_len = 13 if (data[i+2] & 0x01) else 0
            packet_len = 10 + payload_len + 2 + sig_len
            
            if i + packet_len <= len(data):
                if msg_id == 33: # GLOBAL_POSITION_INT
                    payload = data[i+10 : i+10+payload_len]
                    lat = struct.unpack('<i', payload[4:8])[0]
                    lon = struct.unpack('<i', payload[8:12])[0]
                    positions.append((lat, lon))
                i += packet_len
            else: i += 1
        else: i += 1

    # 2. Filter for the "Wheat Field" Cluster
    unique_points = sorted(list(set(positions)))
    lons = [p[1] for p in unique_points]
    mid_lon = (min(lons) + max(lons)) / 2
    flag_points = [p for p in unique_points if p[1] < mid_lon]

    # 3. Generate High-Res Visualization
    lats, lons = zip(*flag_points)
    plt.figure(figsize=(16, 6))
    plt.scatter(lons, lats, s=12, color='darkblue', marker='o')
    plt.gca().set_aspect('equal', adjustable='box')
    plt.axis('off')
    plt.title("Reconstructed Flag from Telemetry Coordinates")
    
    print(f"[*] Processed {len(unique_points)} points.")
    print(f"[*] Found {len(flag_points)} points in the flag cluster.")
    print("[+] Plotting flag... Close the window to exit.")
    plt.show()

if __name__ == "__main__":
    solve_telemetry('telemetry.data')
