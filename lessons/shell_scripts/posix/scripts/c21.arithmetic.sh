#!/usr/bin/env sh
readonly PI=$(echo "scale=15; 4*a(1)" | bc -l) # π via bc's arctangent (-l math lib)
radius=3
# calculate area
area=$(echo "$PI * $radius ^ 2" | bc)
# output results
echo "The area of a circle (radius=$radius) is: $area."
