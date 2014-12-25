#!/usr/bin/env tclsh
# primpt and get input
puts -nonewline "Enter your name: "
flush stdout
gets stdin name
# output result
puts "Hello $name"
