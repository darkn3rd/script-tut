#!/usr/bin/env tcsh
# csh has no floating-point math at all, so float work is delegated to awk
set PI = 3.14159265359
set cosval = `awk "BEGIN {print cos($PI/4)}"`
echo "The cosine of pi/4 is: $cosval"
