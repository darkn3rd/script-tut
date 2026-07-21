#!/usr/bin/env tclsh
set PI     [expr {acos(-1)}]
set radius 3
set area   [expr $PI * $radius ** 2]

puts "The area of a circle (radius=$radius) is: $area."
