#!/bin/tcsh
# integer arithmetic
set width  = 5
set length = 6
@ area = $width * $length
echo "The area of a square(width=$width, length=$length) is $area"
 
# bolean logic
set true = 1
set false = 0
@ result = ($true & $false | $true)
echo "The statement (true AND false OR true) is $result"
