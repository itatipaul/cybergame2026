# CyberGame 2026 — CTF Writeups

My writeups for **CyberGame 2026**, a CTF hosted by [SK-CERT](https://www.sk-cert.sk/). All flags follow the format `SK-CERT{...}`.

---

## 📁 Structure

Each challenge folder contains:
- `challenge.txt` — the original challenge description
- A `*_writeup.md` or named `.md` file — the solution writeup
- Supporting images and files where relevant

---

## 🌐 Offsec (Web / Misc)

### ORMT Series
| Challenge | Writeup |
|-----------|---------|
| ORMT 1 — ORM Injection | [ORM_Injection.md](offsec/ormt/ormt1/ORM_Injection.md) |
| ORMT 2 — Connector Injection | [ORM_Challenge2.md](offsec/ormt/ormt2/ORM_Challenge2.md) |
| ORMT 3 — Template SQLi | [ORM_Challenge3.md](offsec/ormt/ormt3/ORM_Challenge3.md) |

### Return the Blow
| Challenge | Writeup |
|-----------|---------|
| Broken Trust | [Broken_Trust.md](offsec/return%20the%20blow/broken%20trust/Broken_Trust.md) |
| The Notes | [The_Notes.md](offsec/return%20the%20blow/the%20notes/The_Notes.md) |
| Prying Eyes | [Prying_Eyes.md](offsec/return%20the%20blow/prying%20eyes/Prying_Eyes.md) |

### rEquestria
| Challenge | Writeup |
|-----------|---------|
| Lesson Zero | [rEquestria_Lesson_Zero.md](offsec/requestria/requestria-lesson-zero/rEquestria_Lesson_Zero.md) |

### Web Basics
| Challenge | Writeup |
|-----------|---------|
| OTP | [WebBasics_OTP.md](offsec/web%20basics/otp/WebBasics_OTP.md) |

### Jail — SafePS
| Challenge | Writeup |
|-----------|---------|
| SafePS | [JailPS_SafePS.md](offsec/Jail-safeps/jail-SAFEPS/JailPS_SafePS.md) |
| SafePS v2 | [JailPS_SafePS_v2.md](offsec/Jail-safeps/jail-SAFEPSv2/JailPS_SafePS_v2.md) |

### Maverick
| Challenge | Writeup |
|-----------|---------|
| Maverick | [Maverick.md](offsec/marverick/Maverick.md) |
| Maverick — MAVLink Serial Bridge | [Maverick_MAVLink.md](offsec/marverick/Maverick_MAVLink.md) |

### Other (No Writeup Yet)
- `bins/ricettoni` — Binary exploitation
- `future` — Web / XSS bot
- `googleproxy` — SSRF / proxy
- `snailnet` — Web / PHP forum
- `v8` — V8 JavaScript engine exploitation
- `web basics/velvet notes` — Web
- `yipiter` — Web

---

## 🔐 Cryptography

### Miscrypto
| Challenge | Writeup |
|-----------|---------|
| Beethoven's Encryption | [Beethoven_Encryption.md](cryptography/miscrypto/beet/Beethoven_Encryption.md) |
| Encryption Enjoyer | [Encryption_Enjoyer.md](cryptography/miscrypto/encryption%20enjoyer/Encryption_Enjoyer.md) |
| Zippy Zip | [Zippy_Zip.md](cryptography/miscrypto/zippy/Zippy_Zip.md) |

### RSA
| Challenge | Writeup |
|-----------|---------|
| French Tech — Small Semi-Primes | [RSA_Small_Semi_Primes.md](cryptography/rsa/french/RSA_Small_Semi_Primes.md) |

### Other (No Writeup Yet)
- `crypto sanity check` — Encryption, Layers of Encoding, Rotted
- `Return of Elliptic` — Extended Illusion, Twisting, Goldilocs
- `rsa/hellish` — Hellish RSA

---

## 🔬 Forensics

### Administrative Tasks
| Challenge | Writeup |
|-----------|---------|
| Paragraphs — MS Word Forensics | [MS_Word_Forensics.md](forensics/administrative%20tasks/paragraphs/MS_Word_Forensics.md) |
| Tables — Excel Forensics | [Excel_Forensics.md](forensics/administrative%20tasks/tables/Excel_Forensics.md) |
| Portable — PDF Forensics | [PDF_Forensics.md](forensics/administrative%20tasks/portable/PDF_Forensics.md) |

### Network / PCAP
| Challenge | Writeup |
|-----------|---------|
| SPAN Sniff | [SPAN_Sniff.md](forensics/sniff/SPAN_Sniff.md) |

### Telemetry
| Challenge | Writeup |
|-----------|---------|
| Telemetry — MAVLink Drone | [Telemetry.md](forensics/telemetry/Telemetry.md) |

### Volatile Incident
| Challenge | Writeup |
|-----------|---------|
| Activity Check | [Volatile_Activity_Check.md](forensics/volatile%20incident/activity%20check/Volatile_Activity_Check.md) |
| Instance of a Program | [Volatile_Instance_of_Program.md](forensics/volatile%20incident/instance%20of%20a%20program/Volatile_Instance_of_Program.md) |
| Remote Commands | [Volatile_Remote_Commands.md](forensics/volatile%20incident/remote%20commands/Volatile_Remote_Commands.md) |

### Other (No Writeup Yet)
- `diskbasics`
- `insider`
- `signals from the void`

---

## 🦠 Malware Analysis

| Challenge | Writeup |
|-----------|---------|
| Flappy | [Flappy.md](malware%20analysis/flappy/Flappy.md) |
| Lock Screen — Android Ransomware | [Lock_Screen.md](malware%20analysis/lock%20screen/Lock_Screen.md) |
| Lesser Less | [Lesser_Less.md](malware%20analysis/lesser%20less/Lesser_Less.md) |
| Real World Ransomware | [Ransomware_Analysis.md](malware%20analysis/real%20world/Ransomware_Analysis.md) |
| Malware Sanity Check | [Malware_Sanity_Check.md](malware%20analysis/sanity%20check/plaintext%20malware/Malware_Sanity_Check.md) |
| Picking Letters (Reversing) | [Lorem_Reversing.md](malware%20analysis/reversing/picking%20letters/Lorem_Reversing.md) |
| trueorfalse.py (Reversing) | [TrueOrFalse.md](malware%20analysis/true/TrueOrFalse.md) |

### Other (No Writeup Yet)
- `intergalactic` — Beacon, Beacon v0, Warden, Keypad
- `shifted payload`
- `reversing/Matrix sudoku`

---

## 🔍 OSINT

### Travellers
| Challenge | Writeup |
|-----------|---------|
| Public Transit | [Public_Transit.md](osint/travellers/public%20transit/Public_Transit.md) |
| A Beautiful View | [Travellers_Beautiful_View.md](osint/travellers/a%20beautiful%20view/Travellers_Beautiful_View.md) |
| A Little Too Urban | [Travellers_Too_Urban.md](osint/travellers/a%20little%20too%20urban/Travellers_Too_Urban.md) |
| Shopping Centre | [Travellers_Shopping_Centre.md](osint/travellers/shopping%20centre/Travellers_Shopping_Centre.md) |

### Lore of the World
| Challenge | Writeup |
|-----------|---------|
| The Beginnings | [Lore_Beginnings.md](osint/lore%20of%20the%20world/lore%20of%20the%20world%20-%20beginings/Lore_Beginnings.md) |
| Bureaucracy | [Lore_Bureaucracy.md](osint/lore%20of%20the%20world/lore%20of%20the%20world%20-%20bureaucracy/Lore_Bureaucracy.md) |
| Good Doggie | [Lore_Good_Doggie.md](osint/lore%20of%20the%20world/lore%20of%20the%20world%20-%20good%20doggie/Lore_Good_Doggie.md) |

### Other (No Writeup Yet)
- `lore of the world - vantage point`
- `end of the world/epilogue part I`
- `sanity check` — Flag is in the Description, Plain Text
- `target`

---

*Competition hosted by [SK-CERT](https://www.sk-cert.sk/) — Slovak National Cyber Security Centre.*
