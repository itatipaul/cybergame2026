# MS Word Forensics (Paragraphs)

# Author - Senpai
================================================================
CTF WRITE-UP: MS Word Forensics
Challenge: Base64.docm + flag2.zip
Flag: SK-CERT{M5W0RD_F0R3N51C5}
Order: 4312
================================================================

OVERVIEW
--------
We're given a Word macro-enabled document (Base64.docm) and a
password-protected zip (flag2.zip). Same format as the Excel
challenge: find 4 hidden message parts inside the document,
assemble them in order 4-3-1-2 to get the zip password.

The document is a fake educational guide about Base64 encoding.
The content is a red herring. None of the visible text matters.
Everything is hidden in places you'd never look while reading.


THE SAME TRICK AS BEFORE - IT'S A ZIP
--------------------------------------
Base64.docm is a ZIP archive, just like .xlsx and .xlsm files.
The .docm extension means it's a macro-enabled Word document.
Same as .docx but with a VBA macro project bundled inside.

After extracting:
  unzip Base64.docm -d extracted/

The structure looks like:
  word/document.xml       <- main document body
  word/footer1.xml        <- page footer
  word/vbaProject.bin     <- VBA macro code (binary)
  word/media/image1.png   <- embedded images (54 of them!)
  docProps/core.xml       <- document metadata
  docProps/app.xml        <- application metadata
  word/people.xml         <- comment author info

The first step is always: grep everything.
  grep -ri "HIDDEN_MSG" .

Result: nothing. The hiding is more creative this time.


WHERE THE PARTS WERE HIDDEN
-----------------------------

================================================================
MSG_1 = 03c77a9b
Hidden in: word/media/image39.png (a nearly-blank embedded image)
================================================================

The document contains 54 embedded PNG images. Most are screenshots
of code or terminal output used to illustrate the Base64 guide.
They range from small inline icons to wider code blocks.

image39.png stands out:
  - Resolution: 1504 x 520 pixels (much larger than others)
  - File size: only 23,040 bytes (suspiciously small for that size)
  - When opened: appears completely white/blank

The trick: The image contains text written in VERY light grey
(RGB values around 172-253 out of 255) against a white background.
To the human eye viewing the document this is completely invisible.
The contrast difference is so minimal it looks like a blank page.

Digging into the pixel data:
  - Total pixels: 782,080
  - Non-white pixels: only 980 (0.1% of the image!)
  - All non-white pixels clustered in rows 273-288, cols 618-848
  - A region of just 240 x 27 pixels out of the full 1504 x 520

To read it, you extract that region, threshold the pixel values
(anything darker than 240/255 counts as "ink"), scale it up 8x,
and invert the colors. The result is crisp readable text:

    HIDDEN_MSG_1_{03c77a9b}

The text was rendered in a light monospace font directly into the
image pixels. Zero chance of finding this by eyeballing the document.
You need to programmatically scan pixel values.

Key lesson: An image that LOOKS blank may not BE blank.
Always check pixel value distributions on suspicious images.


================================================================
MSG_2 = 47d0241a
Hidden in: word/document.xml (as a Base64 string in the body XML)
================================================================

The main document content lives in word/document.xml. This file
stores every paragraph, run of text, image reference, and style.
It's normally hundreds of KB of dense XML.

Buried in the XML, mixed in with image embedding references and
paragraph markup, is this string:

    SElEREVOX01TR18yX3s0N2QwMjQxYX0=

It looks like a random ID or checksum value. It's positioned
where you'd normally expect a relationship ID or internal
reference. Easy to scroll past.

Decode it:
    base64.b64decode("SElEREVOX01TR18yX3s0N2QwMjQxYX0=")
    = b"HIDDEN_MSG_2_{47d0241a}"

The challenge is themed around Base64 encoding for a reason.
The author is basically telling you: the hiding method IS Base64.
The entire fake educational document about Base64 is a hint that
Base64 encoded strings are the weapon of choice here.

Other Base64 strings found in the document that were NOT the flag:
    SGkhIE1pY2hhZWwgSmFja3NvbiBoZXJlIGFnYWluIDop
    = "Hi! Michael Jackson here again :)"  <- same troll as the Excel challenge

    aHR0cHM6Ly93d3cueW91dHViZS5jb20vc2hvcnRzLzJCeEdTWWJUSHl3
    = "https://www.youtube.com/shorts/2BxGSYbTHyw"  <- a YouTube link (rickroll?)

Key lesson: Search for Base64 patterns ([A-Za-z0-9+/]{20,}={0,2})
across all XML files and decode every match.


================================================================
MSG_3 = 5caf69d6
Hidden in: word/footer1.xml (white text, 2pt font, every page)
================================================================

Every page of the document has a footer. The footer XML is stored
separately in word/footer1.xml.

The footer appears completely empty when you open the document.
But the XML tells a different story.

The footer contains the full string HIDDEN_MSG_3_{5caf69d6}
written out character by character, each letter in its own XML
run element (<w:r>). Every single character has these properties:

    <w:color w:val="FFFFFF" w:themeColor="background1"/>
    <w:sz w:val="4"/>
    <w:szCs w:val="4"/>

Breaking that down:
  - color FFFFFF = pure white (same as page background)
  - sz val="4" = font size 2pt (half points, so 4 = 2pt)

Two layers of hiding:
  1. White text on a white background = invisible by color
  2. 2pt font size = even if you changed the color, it would be
     one pixel tall and unreadable at normal zoom

The text is literally there on every single page of the document,
running invisibly across the footer. It has been on your screen
the entire time you were reading the Base64 guide.

Also interesting: some runs use the font "Al Tarikh" (an Arabic
script font) applied to Latin characters. This is another layer
of visual obfuscation that would cause characters to render
strangely if you somehow managed to see the text.

Key lesson: Word footers are often ignored. Always check footer
and header XML separately. White text on white background is a
classic steganography-lite technique.


================================================================
MSG_4 = 1ff1519f
Hidden in: word/vbaProject.bin (inside the VBA macro binary)
================================================================

The .docm extension means the file contains VBA macros.
The macro code is stored in a binary format in word/vbaProject.bin.
This is not plain text XML like the rest of the document.

Running strings on the binary:
    strings word/vbaProject.bin

Among the output, one entry stands out:
    SElEREVOX01TR180X3sxZmYxNTE5Zn0=

Decode it:
    base64.b64decode("SElEREVOX01TR180X3sxZmYxNTE5Zn0=")
    = b"HIDDEN_MSG_4_{1ff1519f}"

The VBA macro binary also contained:
  - A function called "Base64Decode" (fitting for this challenge)
  - Functions called "VersionValidator", "DocumentFormatter",
    "DocumentAnalyzer" with AutoOpen triggers
  - References to XML DOM objects (suggesting the macro reads
    or modifies document content at runtime)

The VBA code appears designed to look like a legitimate document
automation macro. The base64 string is embedded as a string
literal inside one of these functions, blending in with other
internal strings like function names and object references.

Key lesson: Always extract VBA macro content from .docm/.xlsm
files. The binary is not encrypted by default. The strings command
pulls out readable content. Any base64-looking string is worth
decoding immediately.


ASSEMBLING THE PASSWORD
------------------------
Order given: 4-3-1-2

MSG_4 = 1ff1519f
MSG_3 = 5caf69d6
MSG_1 = 03c77a9b
MSG_2 = 47d0241a

Password = 1ff1519f5caf69d603c77a9b47d0241a

Unzip flag2.zip with this password:
    unzip -P 1ff1519f5caf69d603c77a9b47d0241a flag2.zip

Flag: SK-CERT{M5W0RD_F0R3N51C5}
(Translation: MS WORD FORENSICS in leet speak)


FULL METHODOLOGY FOR WORD DOCUMENT FORENSICS
---------------------------------------------

Step 1: Extract the ZIP
    unzip file.docm -d extracted/
    cd extracted/

Step 2: Grep all XML for obvious patterns
    grep -ri "HIDDEN" .
    grep -ri "FLAG" .
    grep -ri "password" .
    If nothing: get creative.

Step 3: Check document body for invisible text
    word/document.xml - parse every <w:r> run
    Look for: w:vanish (hidden text flag)
    Look for: color FFFFFF or matching background
    Look for: sz val <= 4 (font size 1-2pt)
    Look for: w:del (deleted/tracked-change text)

Step 4: Check headers and footers SEPARATELY
    word/header1.xml, header2.xml
    word/footer1.xml, footer2.xml
    These are separate files - grepping document.xml won't find them

Step 5: Scan all images
    List image dimensions and file sizes
    Flag any images that are large resolution but tiny file size
    For suspicious images: load with PIL, count non-white pixels
    Crop and scale up the region with content
    Try threshold / contrast enhancement to reveal faint text

Step 6: Scan all XML for Base64 strings
    grep -oP '[A-Za-z0-9+/]{20,}={0,2}' word/*.xml
    Decode every match with Python base64.b64decode()
    Don't ignore strings that look like internal IDs

Step 7: Extract VBA macro strings
    strings word/vbaProject.bin
    Look for base64 strings and decode them
    Look for hardcoded string literals
    If you need the actual VBA source code, use olevba:
        pip install oletools
        olevba word/vbaProject.bin

Step 8: Check metadata files
    docProps/core.xml   <- title, subject, creator, description
    docProps/app.xml    <- Manager, Company fields (used in Excel chall)
    word/people.xml     <- comment author userIds (used in Excel chall)
    word/settings.xml   <- document settings and rsids
    customXml/          <- custom XML data parts

Step 9: Check footnotes and endnotes
    word/footnotes.xml
    word/endnotes.xml
    These are separate files and often overlooked

Step 10: Check theme and style files for unusual content
    word/theme/theme1.xml
    word/styles.xml


TOOLS USED
-----------
- unzip (extraction)
- grep (pattern search across XML)
- Python + PIL/Pillow (image pixel analysis)
- Python base64 module (decode base64 strings)
- strings (extract text from VBA binary)
- numpy (pixel array analysis for image39)


COMPARISON WITH THE EXCEL CHALLENGE
-------------------------------------
Both challenges used the same author ("Michael Jackson") and same
troll messages. The hiding techniques escalated:

Excel challenge hid parts in:
  - Cell data at extreme row/column coordinates
  - Comment metadata (Notes at row 816,000+)
  - CHAR() formula obfuscation referencing data cells
  - XML metadata fields (persons/person.xml userId)

Word challenge hid parts in:
  - Near-invisible grey pixels in an embedded image
  - Base64 string in document body XML
  - White 2pt text in the page footer
  - Base64 string in VBA macro binary

The escalation in creativity is clear. The Word challenge required
pixel-level image analysis which the Excel challenge didn't need.
Both rewarded the same core skill: treating Office files as ZIP
archives and systematically examining every component file.


FINAL NOTES FOR BEGINNERS
---------------------------
The name "Base64.docm" was itself a hint. The challenge is telling
you: the encoding method used is Base64, and it involves a Word
macro file. The educational content about Base64 inside the
document is a double bluff - it teaches you the tool you need
to decode the hidden messages while distracting you with text.

When you see a themed challenge document, the theme is usually
pointing at the technique. A document about encryption hides
things with encryption. A document about steganography hides
things in images. A document about Base64 hides things in Base64.

Read the room.

================================================================
FLAG: SK-CERT{M5W0RD_F0R3N51C5}
================================================================
