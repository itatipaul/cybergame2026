# Telemetry

This forensics challenge, titled Telemetry, tasks analysts with investigating a MAVLink drone log to uncover a hidden flag. While the file contains decoy strings and intentionally broken metadata, the true flag is encoded geographically within the drone's flight coordinates.
1. Challenge Identification

    File: telemetry.data (MAVLink 2.0 Binary)

    Context: Suspicious drone flight over a field ("Wheat Field").

    Points of Interest: 477 unique GPS points extracted from the log.

2. Initial Triage & The "Honeytoken" Trap

A simple string analysis of the file reveals a decoy flag:
flag{telemetry_payloads_are_a_trap}

This is a classic anti-forensics "honeytoken." It is placed in the STATUSTEXT or GCS message fields to mislead analysts into thinking they have solved the challenge. The hint regarding "circles in the wheat" implies that we must look at the physical path of the drone rather than its telemetry metadata.
3. Protocol Analysis

The file uses the MAVLink 2.0 protocol. By parsing the binary structure (starting with the magic byte 0xfd), we can isolate Message ID #33: GLOBAL_POSITION_INT.

Each Message #33 packet contains the core data needed to reconstruct the drone's path:

    Latitude (lat): Scaled by 107.

    Longitude (lon): Scaled by 107.

    Altitude (alt): Millimeters above MSL.

4. Data Extraction & Filtering

Using a custom Python script, we extract all unique latitude and longitude pairs. Analysis of these coordinates reveals two distinct clusters:

    The Decoy Cluster (High Longitude): Coordinates at a higher altitude/longitude that trace out a distraction pattern.

    The Flag Cluster (Lower Longitude): A dense set of 474 unique points located in the "wheat field" area.

By calculating the mid_lon of the entire set, we can filter out the decoy data to isolate the flag.
5. Visual Reconstruction

Standard terminal outputs often suffer from "aspect ratio distortion" (characters are taller than they are wide), making the flight path look squashed or incomplete.

By mapping the coordinates to a high-resolution 2D scatter plot using a tool like matplotlib or a normalized grid, the drone's flight path transforms into legible characters. The drone was essentially used as a "digital pen" to trace characters in the field.
6. Flag Discovery

The 474 unique points in the wheat cluster trace out the following message:

SK-CERT{MY_QU4D_W45_H1J4CK3D}
7. Tools & Techniques Summary

    Binary Parsing: Custom Python logic using struct.unpack to read raw int32 GPS fields.

    MAVLink 2.0 Awareness: Correctly handling the 10-byte header and optional 13-byte signature to maintain packet synchronization.

    Geospatial Visualization: Plotting X (Longitude) and Y (Latitude) to reveal hidden text.

    Coordinate Normalization: Using column-grouping logic to verify character segments in distorted terminal views.
