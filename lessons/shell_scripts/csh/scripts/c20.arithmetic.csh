#!/usr/bin/env tcsh
# csh has no floating-point math at all, so float work is delegated to bc
set PI = 3.14159265359
set radius = 3
set area = `echo "$PI * $radius ^ 2" | bc`
echo "The area of a circle (radius=$radius) is: $area."
