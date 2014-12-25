#!/usr/bin/env tclsh
# acquire num of args and script name
set arg_count   $argc;  # get num of arguments
set script_name $argv0; # get script name

if { $arg_count != 2 } {
  # print usage statement to standard error
  puts stderr "\nYou need to enter two numbers: \n"
  puts stderr "   Usage: $script_name \[num1\] \[num2\]\n"
} else {
  # get sum of both arguments
  set sum [expr [lindex $argv 0] + [lindex $argv 1]]
  # print results of both arguments and summation
  puts "The sum of [lindex $argv 0] and [lindex $argv 1] is $sum"
}
  
