#!/bin/sh
# Lab 5: convert staff-broken.csv from <SOURCE> to UTF-8
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv
iconv -f RK1048 -t UTF-8 "$in" > "$out"
sed -i 's/$/\r/' "$out"
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
