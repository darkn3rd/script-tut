#!/usr/bin/tclsh
# acquire num of arguments
set arg_count $argc                 ;# get num of arguments
set last      [expr $arg_count - 1] ;# get index of last element
set first     0                     ;# set index of first element

puts "The arguments passed are:"
# iterative loop to enumerate args
for {set count $first} {$count <= $last} {incr count 1} {
  # output each element from $last_item to 0
  puts "  item [expr $count + 1]: [lindex $argv $count]"
}