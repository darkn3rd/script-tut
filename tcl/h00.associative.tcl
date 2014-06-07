#!/usr/bin/tclsh
# insert one element at a time
set ages(bob)   34
set ages(ed)    58
set ages(steve) 32
set ages(ralph) 23
set ages(deb)   46
set ages(kate)  19
# enumerate & print keys
puts "Keys (names): [array names ages]"
# enumerate & print values
puts -nonewline "Values (set ages): "
puts [lsearch -all -inline -regexp [split [array get ages]] {[0-9]+}]
