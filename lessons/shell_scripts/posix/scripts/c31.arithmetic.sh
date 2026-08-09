#!/usr/bin/env sh
# testbox: title="PI via bc arctangent, widened awk OFMT precision"
readonly PI=$(echo "scale=15; 4*a(1)" | bc -l) # π via bc's arctangent (-l math lib)

# widen awk's OFMT (default %.6g) so the extra precision from PI is visible
echo "The cosine of pi/4 is: $(awk "BEGIN {OFMT=\"%.17g\"; print cos($PI/4)}")"
