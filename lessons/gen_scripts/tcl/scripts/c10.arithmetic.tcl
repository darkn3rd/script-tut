#!/usr/bin/env tclsh
# calculate bolean logic
set result [expr True && False || True]
# output results
puts "The statement (true AND false OR true) is: $result"
