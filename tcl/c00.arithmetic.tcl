#!/usr/bin/env tclsh
# declare variables
set width 5; set length 6
# calculate integer arithmetic
set area [expr $width * $length]
# output results
puts "The area of a square(width=$width, length=$length) is $area"