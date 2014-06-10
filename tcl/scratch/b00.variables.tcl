#!/usr/bin/tclsh
set num    5
set char   a
set string "This is a string"

set output ""
append output "Number is " $num "."
puts $output

set output ""
append output "Character is a '" $char "'." 
puts $output

set output ""
append output "String is \"" $string "\"."
puts $output
