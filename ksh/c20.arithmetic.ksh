#!/bin/ksh
typeset -Fr PI=3.14159265359           # set approximation of π
radius=3                               # set radius
area=$(($PI * pow($radius,2)))         # calculate area
print "The area of a circle is $area"  # output result
