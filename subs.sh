#!/bin/bash
#subs.sh
cat $1 | tr '[:upper:]' '[:lower:]' | sed \
-e 's/a/L/g' \
-e 's/b/Y/g' \
-e 's/c/V/g' \
-e 's/d/F/g' \
-e 's/e/U/g' \
-e 's/f/Q/g' \
-e 's/g/M/g' \
-e 's/h/G/g' \
-e 's/i/R/g' \
-e 's/j/H/g' \
-e 's/k/B/g' \
-e 's/l/S/g' \
-e 's/m/N/g' \
-e 's/n/A/g' \
-e 's/o/X/g' \
-e 's/p/J/g' \
-e 's/q/C/g' \
-e 's/r/W/g' \
-e 's/s/K/g' \
-e 's/t/I/g' \
-e 's/u/E/g' \
-e 's/v/O/g' \
-e 's/w/P/g' \
-e 's/x/D/g' \
-e 's/y/T/g' \
-e 's/z/Z/g'
echo
exit 0
