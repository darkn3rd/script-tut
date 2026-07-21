#!/usr/bin/env ksh
# ksh93 has real trig functions built into arithmetic evaluation; note no
# "typeset -F" here, since its default display precision would truncate π
typeset -r PI=$(( acos(-1) ))          # π
radius=3                               # set radius
area=$(($PI * pow($radius,2)))         # calculate area
print "The area of a circle (radius=$radius) is: $area."  # output result
