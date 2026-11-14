# Lab 5 — Encoding forensics

Name: Nurtas Zhanat · Date: 14.11.26 · Tools: Pop!_OS terminal, LibreOffice, Excel

## What I received
In MS Excel, most of the text was visible, but kazakh letters were messed up

In LibreOffice and cat, everything was diamonds with question marks

## Diagnosis (made before the fix)
- file said: staff-broken.csv: Non-ISO extended-ASCII text, with CRLF line terminators  (evidence/file-before.txt)
- First 16 bytes: 4944 3bd4 e0ec e8eb  (evidence/hexdump-before.txt)
- Encoding: RK1048 — because Ә = A3
- Line ending: CRLF — because "file" says "with CRLF line terminators" (evidence/file-before.txt)
- BOM: no — because 4944 bytes in the beginning; in the fixed file I added it because otherwise the file wouldn't open correctly in Excel

## Fix
```
#!/bin/sh
# Lab 5: convert staff-broken.csv from <SOURCE> to UTF-8
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv
iconv -f RK1048 -t UTF-8 "$in" > "$out"
sed -i 's/$/\r/' "$out"
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
```

## Verification
The file is now encoded in UTF-8 with BOM, CRLF and CR line terminators
(evidence/opens-correctly.png)

## What did not work the first time
The file didn't decode properly because i used a wrong encoding source. Windows-1251 instead of RK1048