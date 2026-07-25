#!/usr/bin/env ksh
# set approximation of π
typeset -Fr PI=3.14159265359
# print calculaton of cos(π/4)
print The cosine of pi/4 is: $((cos($PI/4)))
