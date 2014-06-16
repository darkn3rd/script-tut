#!/usr/bin/tclsh
# acquire num of args and script name
set arg_count   $argc;  # get num of arguments
set script_name $argv0; # get script name

if { $arg_count != 2 } {
  puts "You need to enter two numbers: \n\n\tUsage:\"$script_name\" num1 num2.\n";
} else {
  puts "The sum of [lindex $argv 0] and [lindex $argv 1] is [expr [lindex $argv 0] + [lindex $argv 1]]"
}
  
