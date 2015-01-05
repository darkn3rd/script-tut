#!/usr/bin/env sh
# integer arithmatic
width=5; length=6
area=$(($length * $width))
echo "The area of a square (width=$width, length=$length) is $area"
 
# boolean logic
true=1; false=0
result=$(($true && $false || $true))
echo "The statement (true AND false OR true) is $result"