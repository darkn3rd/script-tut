#!/usr/bin/env ksh
# ksh93 has real trig functions built into arithmetic evaluation; note no
# "typeset -F" here, since its default display precision would truncate π
typeset -r PI=$(( acos(-1) ))
# print calculaton of cos(π/4)
print The cosine of pi/4 is: $((cos($PI/4)))
