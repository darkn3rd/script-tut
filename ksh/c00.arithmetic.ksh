#!/bin/ksh
# integer arithmatic
width=5; length=6
area=$(($length * $width))
print "The area of a square (width=$width, length=$length) is $area"
 
# boolean logic
true=1; false=0
result=$(($true && $false || $true))
print "The statement (true AND false OR true) is $result"
