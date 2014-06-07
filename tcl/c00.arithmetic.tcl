#!/usr/bin/tclsh
# integer arithmetic
set width 5; set length 6
set area [expr $width * $length]
puts "The area of a square(width=$width, length=$length) is $area"
 
# bolean logic
set result [expr True && False || True]
puts "The statement (true AND false OR true) is $result"
