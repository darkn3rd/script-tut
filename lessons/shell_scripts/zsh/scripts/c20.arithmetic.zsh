#!/usr/bin/env zsh
declare -r PI=3.14159265359           # set approximation of π
radius=3                              # set radius
area=$(echo "$PI * $radius ^ 2" | bc) # calculate area, no float in bash
echo "The area of a circle (radius=$radius) is: $area." # output result
