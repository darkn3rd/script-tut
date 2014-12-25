#!/usr/bin/env tclsh
# acquire num of arguments
set arg_count   $argc        ;# get num of arguments
set count       1            ;# set initial count

puts "The arguments passed are:"

# collection loop to enumerate args
foreach arg $argv {
  puts "  item $count: $arg" ;# output count and arg
  incr count 1               ;# counter
}