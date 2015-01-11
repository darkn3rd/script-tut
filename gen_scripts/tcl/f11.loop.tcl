#!/usr/bin/env tclsh
# count loop using while loop
set count 10               ;# initialize counter
while {$count > 0} {
    puts "Count is $count" ;# ouput counter
    incr count -1          ;# decrement counter
}
