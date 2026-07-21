#!/usr/bin/env tcsh
# csh has no floating-point math at all, so float work is delegated to bc
# and awk; bc's -l math library defines a() (arctangent), giving
# full-precision π, and awk's OFMT is widened (default %.6g) so that
# extra precision is actually visible in the output
set PI = `echo "scale=15; 4*a(1)" | bc -l`
set cosval = `awk -v OFMT=%.17g "BEGIN {print cos($PI/4)}"`
echo "The cosine of pi/4 is: $cosval"
