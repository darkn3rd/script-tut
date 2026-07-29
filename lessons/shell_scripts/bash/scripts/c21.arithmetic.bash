#!/usr/bin/env bash
declare -r PI=$(echo "scale=15; 4*a(1)" | bc -l) # π via bc's arctangent (-l math lib)
radius=3                              # set radius
area=$(echo "$PI * $radius ^ 2" | bc) # calculate area, no float in bash
echo "The area of a circle (radius=$radius) is: $area." # output result
