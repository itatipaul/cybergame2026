# Beethoven's Encryption
Author - Senpai

Challenge Write-up: Beethoven's Encryption

Challenge Overview

    Name: Beethoven's Encryption

    Category: Cryptography / Steganography

    Objective: Decode a hidden message represented as musical notation on a treble clef staff.

1. Initial Analysis

The challenge provides an image (beethoven.png) containing two lines of musical notation. Initial observations include:

    Clef: Treble Clef.

    Note Types: A mix of quarter notes (filled heads with stems) and whole notes (hollow heads).

    Observation: Standard musical notes only range from A to G. Since the resulting string contains numbers (1, 3, 4, 5, 7) and letters like 'S' and 'M', this is not a simple rhythmic or melodic transcription. It is a Symbol Substitution Cipher.

2. Decoding Process

To decode the image, each note's position on the staff must be mapped to a specific alphanumeric character.
Step A: Mapping the Notes

By analyzing the vertical position of each note on the staff (Lines: E-G-B-D-F; Spaces: F-A-C-E):

    The first note is on the top line (F).

    The second note is in the second space from the bottom (A).

    The third note is in the third space from the bottom (C).

Step B: Tooling

Using a specialized tool like dCode.fr (Music Sheet Cipher), the visual symbols were mapped against known musical substitution alphabets. The tool automates the translation of note positions and types (quarter vs. whole) into a character string.

3. Flag Extraction

The decoded string initially appeared as:
SKCERTTH151SMU51C70MY34R5

By applying Leetspeak translation:

    TH15 → THIS

    15 → IS

    MU51C → MUSIC

    70 → TO

    34R5 → EARS

The final phrase revealed: "THIS IS MUSIC TO MY EARS".

4. Final Flag

The platform accepted the raw string without underscores or hyphens:
SKCERTTH151SMU51C70MY34R5
Lessons Learned

    Format Matters: CTF flags often require strict adherence to the output of the decoding tool; adding "standard" separators like underscores can result in a "Wrong Answer" even if the content is correct.

    Symbol Substitution: When musical notes represent characters outside the A-G range, they are functioning as a font for a substitution cipher, not as literal music.
