# PBES PDF Forensics (Portable)

================================================================================
  CTF CHALLENGE 3 — WRITE-UP
  File: PBES-512.pdf + flag3.zip
  Flag: SK-CERT{WHY_15_MJ_3V3RYWH3R3}
================================================================================

OVERVIEW
--------
The challenge provides a PDF document (PBES-512.pdf) and an encrypted zip archive
(flag3.zip). The README instructs us to find 4 hidden messages inside the PDF, each
in the format HIDDEN_MSG_x_{xxxxxxxx}, then combine their 8-character hex values in
the order 4321 to form the zip password.

    Final password construction (order 4321):
        MSG_4 + MSG_3 + MSG_2 + MSG_1
        = 85add2c0 + 0a6899cf + b100bf91 + 4abcc69f
        = "85add2c00a6899cfb100bf914abcc69f"

    Flag: SK-CERT{WHY_15_MJ_3V3RYWH3R3}


RECONNAISSANCE
--------------
Initial inspection of the PDF:

    $ python3 -c "
    from pypdf import PdfReader
    r = PdfReader('PBES-512.pdf')
    print('Pages:', len(r.pages))
    print('Metadata:', r.metadata)
    print('Root keys:', list(r.trailer['/Root'].keys()))
    "

Key observations:
  - PDF version 1.5, 15 pages total (only 12 contain visible content)
  - Producer: "macOS Version 26.3 Quartz PDFContext; pyHanko 0.32.0"
    (pyHanko is a Python PDF digital signing library)
  - Root dictionary has: /AcroForm (form fields), /Names (embedded files),
    /Outlines (bookmarks), /StructTreeRoot
  - /Names contains /EmbeddedFiles — there is a file attached to the PDF
  - Pages 13, 14, 15 exist but have empty content streams ("q Q")


================================================================================
MSG_4 — Nested Embedded File Attachment
================================================================================

LOCATION: /Names -> /EmbeddedFiles -> "fonts.zip" -> nested archive

EXTRACTION:

The PDF's /Names dictionary contained an /EmbeddedFiles entry pointing to an
embedded file called "fonts.zip":

    from pypdf import PdfReader
    reader = PdfReader('PBES-512.pdf')
    root = reader.trailer['/Root']
    names = root['/Names'].get_object()
    ef = names['/EmbeddedFiles']
    # ef['/Names'] = ['fonts.zip', IndirectObject(7, 0, ...)]
    file_obj = ef['/Names'][1].get_object()
    data = file_obj['/EF']['/F'].get_object().get_data()
    open('fonts.zip', 'wb').write(data)

Extracting fonts.zip revealed two files:

    fonts.zip
    ├── another_pass        (19 bytes, plaintext: "verysecretpassword")
    └── another_part.zip    (234 bytes, password-protected)

Using the password from another_pass to open another_part.zip:

    $ unzip -P verysecretpassword another_part.zip
    # extracts: another_part.txt

Contents of another_part.txt:
    HIDDEN_MSG_4_{85add2c0}

MSG_4 = 85add2c0


================================================================================
MSG_3 — X.509 Certificate Subject Alternative Name
================================================================================

LOCATION: PKCS#7 digital signature -> certificate chain -> SAN extension

EXTRACTION:

The PDF contains a digital signature in an /AcroForm widget field named "Sig1".
The signature value (/V) holds a PKCS#7/CMS DER-encoded blob. Parsing the
certificate chain embedded in that blob reveals the hidden message:

    from pypdf import PdfReader
    from cryptography.hazmat.primitives.serialization.pkcs7 import load_der_pkcs7_certificates

    reader = PdfReader('PBES-512.pdf')
    sig_field = reader.trailer['/Root']['/AcroForm']['/Fields'][0].get_object()
    sig_value = sig_field['/V'].get_object()
    sig_bytes = bytes(sig_value['/Contents'])

    certs = load_der_pkcs7_certificates(sig_bytes)
    for cert in certs:
        for ext in cert.extensions:
            print(ext.oid._name, ':', ext.value)

The PKCS#7 structure contains two certificates:
  1. End-entity cert  — Subject: C=MJ, O=MJ, CN=MJ signature
  2. Intermediate CA — Subject: C=MJ, O=MJ Intermediate, CN=MJ Intermediate CA

The Intermediate CA certificate carries a Subject Alternative Name extension:

    Extension OID: subjectAltName
    Value: <SubjectAlternativeName([<DNSName(value='HIDDEN_MSG_3_{0a6899cf}')>])>

MSG_3 = 0a6899cf

NOTE: The entire certificate chain uses the organisation "MJ" — a recurring theme
across all three challenges referencing a fictitious "Michael Jackson" account.


================================================================================
MSG_2 — Invisible FreeText Annotation on Hidden Page
================================================================================

LOCATION: Page 14 (invisible — not part of the visible page range) -> /Annots

EXTRACTION:

Pages 13–15 exist in the PDF but contain only an empty content stream ("q Q"),
making them invisible in any PDF viewer. Page 14 carries a /FreeText annotation
titled "michaeljackson":

    reader = PdfReader('PBES-512.pdf')
    page14 = reader.pages[13]   # 0-indexed
    ann = page14.get_object()['/Annots'][0].get_object()

    print('Title :', ann['/T'])       # 'michaeljackson'
    print('Rect  :', ann['/Rect'])    # [266.96, 0, 329.04, 718.0]
    print('Contents:', ann['/Contents'])

The /Contents value contains each character on a separate line (with surrounding
spaces), forming the message — but the annotation is placed so that its rendered
appearance stream uses a coordinate transform that moves the text far off the
visible page area (x offset of −266.96 points), making it invisible in viewers:

    /Contents:
         H 
         I 
         D 
         D 
         E 
         N 
         _ 
         M 
         S 
         G 
         _ 
         2
         _ 
         { 
         b 
         1 
         0 
         0 
         b 
         f 
         9 
         1 
         } 

MSG_2 = b100bf91


================================================================================
MSG_1 — Glyph Images Watermarked Over the Signature Box
================================================================================

LOCATION: Page 12 (last visible page) -> signature area -> individual glyph XObjects

This was the most visually deceptive hiding technique. The page's digital signature
field displays as a solid black rectangle in any PDF viewer. The hidden message is
written on top of that black rectangle using individual character glyph images, each
placed as a separate XObject image resource.

DISCOVERY:

Extracting all images from the PDF with pdfimages revealed a cluster of small
images (ranging from ~24×46 to ~56×72 pixels) alongside larger document images.
Closer inspection showed these were arranged in pairs — one image containing the
rendered glyph, and one all-white mask image of identical dimensions.

The page 12 /Resources /XObject dictionary contained entries Im6 through Im25.
Im25 (412×112 px) is the dark-grey background rectangle of the signature box.
Im6–Im24 are the individual character glyph images.

DECODING THE SEQUENCE:

The PDF content stream for page 12 contains a series of matrix+Do operations
that place each glyph at a specific x-coordinate within the signature area (y ≈ 123):

    q  11.56  0  0  18.46  316.42  123.59  cm  /Im6   Do  Q
    q   7.47  0  0  15.74  326.18  124.68  cm  /Im7   Do  Q
    q   9.00  0  0  18.66  332.50  123.61  cm  /Im8   Do  Q
    q   8.58  0  0  18.73  341.17  123.77  cm  /Im8   Do  Q   ← Im8 used TWICE
    q   8.58  0  0  16.42  349.20  125.32  cm  /Im9   Do  Q
    q   8.86  0  0  18.23  356.85  124.43  cm  /Im10  Do  Q
    q   6.24  0  0  14.45  367.19  119.54  cm  /Im11  Do  Q   ← Im11 used 3×
    q  11.30  0  0  18.37  374.96  123.36  cm  /Im12  Do  Q
    q  10.07  0  0  20.76  385.84  122.62  cm  /Im13  Do  Q
    q  11.82  0  0  20.44  395.05  122.90  cm  /Im14  Do  Q
    q   6.94  0  0  13.45  407.29  120.79  cm  /Im11  Do  Q
    q   7.59  0  0  19.13  415.55  123.77  cm  /Im15  Do  Q
    q   6.94  0  0  13.45  423.51  120.79  cm  /Im11  Do  Q
    q  14.25  0  0  18.53  428.56  123.90  cm  /Im16  Do  Q
    q  12.33  0  0  19.28  437.84  123.33  cm  /Im17  Do  Q
    q  10.57  0  0  15.85  447.50  123.98  cm  /Im18  Do  Q
    q   9.78  0  0  18.28  457.04  123.79  cm  /Im19  Do  Q
    q   9.66  0  0  19.10  486.92  123.56  cm  /Im20  Do  Q
    q  11.56  0  0  17.12  475.93  123.34  cm  /Im20  Do  Q   ← Im20 used TWICE
    q  10.64  0  0  18.05  496.32  124.37  cm  /Im21  Do  Q
    q  11.10  0  0  18.45  506.16  124.63  cm  /Im22  Do  Q  (wait — Im11 again)
    q  11.56  0  0  17.12  475.93  123.34  cm  /Im20  Do  Q
    ...

Sorting all placements by x-coordinate and rendering the glyph images in that order
(scaling each up 4× for legibility) produces:

    H  I  D  D  E  N  _  M  S  G  _  1  _  {  4  a  b  c  c  6  9  f  }

Breaking down the glyph-to-character mapping:
    Im6  = H       Im7  = I       Im8  = D  (used for both D's in HIDDEN)
    Im9  = E       Im10 = N       Im11 = _  (underscore, used 3 times)
    Im12 = M       Im13 = S       Im14 = G
    Im15 = 1       Im16 = {       Im17 = 4
    Im18 = a       Im19 = b       Im20 = c  (used for both c's)
    Im21 = 6       Im22 = 9       Im23 = f
    Im24 = }

The full text watermarked over the signature box reads:
    HIDDEN_MSG_1_{4abcc69f}

MSG_1 = 4abcc69f

Why the glyphs were invisible: The background (Im25, a 412×112 near-black rectangle
with pixel values 22–25 out of 255) is rendered first, and the glyph images are
painted on top. In a PDF viewer, the signature field's appearance stream supersedes
this rendering, and the dark box simply appears solid black. Only by extracting the
raw XObject images and reassembling them in x-position order does the text become
legible.


================================================================================
PASSWORD ASSEMBLY & FLAG EXTRACTION
================================================================================

Order specified in README: 4321

    PASSWORD = MSG_4 + MSG_3 + MSG_2 + MSG_1
             = "85add2c0" + "0a6899cf" + "b100bf91" + "4abcc69f"
             = "85add2c00a6899cfb100bf914abcc69f"

    $ unzip -P 85add2c00a6899cfb100bf914abcc69f flag3.zip
    Archive:  flag3.zip
      extracting: flag3.txt

    $ cat flag3.txt
    SK-CERT{WHY_15_MJ_3V3RYWH3R3}


================================================================================
BONUS: IS PBES-512 A REAL ENCRYPTION STANDARD?
================================================================================

No. PBES-512 ("Poultry-Based Encryption Standard") is an elaborate joke document.
The flag itself — "WHY IS MJ EVERYWHERE" in leetspeak — confirms its humorous intent.

Dead giveaways:

  Authors:
    - Dr. Henrietta K. Fowler    (fowl = poultry)
    - Prof. Clive R. Hatchman    (to hatch = what eggs do)
    - Dr. Amelia Eggsworth       (eggs)
    - Institute for Avian Security Standards (IASS)

  Algorithm:
    - Entropy sourced from live chickens: step irregularity, wing-flap jitter,
      head-tilt variance, and "spontaneous cluck emission patterns"
    - Minimum sampling rate: 128 clucks/sec per "ISO-Hen-27001"
    - Key derivation via "FeatherHash512" and "Egg-Laying Frequency Modulation (ELFM)"
    - Key exchange via "Coop-to-Coop Handshake (CCH)"
    - Forward secrecy achieved through "Molting Rotation"

  Threat model:
    - Defends against "Q-Roosters" (quantum roosters running Grover's algorithm)
    - Attacker assumed NOT to possess "Certified Feather Injection Hardware (FIH)"
    - Security degrades if adversary achieves "cross-coop molting synchronization"

  Compliance: Targets "farm-to-cloud" deployment environments

The document is a well-crafted parody of real cryptographic standard papers
(complete with correct LaTeX-style math notation, proper threat model structure,
and a formal abstract), but every concrete technical claim involves chickens.


================================================================================
SUMMARY OF ALL 4 HIDDEN MESSAGES
================================================================================

  MSG   Value       Hiding Technique
  ----  ----------  -------------------------------------------------------
  1     4abcc69f    Glyph images overlaid on signature box (page 12)
  2     b100bf91    FreeText annotation on hidden page 14 (off-screen coords)
  3     0a6899cf    X.509 SAN extension in intermediate CA certificate
  4     85add2c0    Nested password-protected zip in embedded file attachment

================================================================================
