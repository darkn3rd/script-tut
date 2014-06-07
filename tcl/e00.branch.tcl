#!/usr/bin/tclsh
# prompt and get input
puts -nonewline "Input a number: "
flush stdout
gets stdin number
# evaluate input & print result
if {$number > 0} {
  puts "Number is greater than 0"
} elseif {$number < 0} {
  puts "Number is less than 0"
} else {
  puts "Number is 0"
}
