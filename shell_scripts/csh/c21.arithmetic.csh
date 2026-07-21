#!/usr/bin/env tcsh
# csh has no floating-point math at all, so float work is delegated to bc;
# bc's -l math library defines a() (arctangent), giving full-precision π
set PI = `echo "scale=15; 4*a(1)" | bc -l`
set radius = 3
set area = `echo "$PI * $radius ^ 2" | bc`
echo "The area of a circle (radius=$radius) is: $area."
