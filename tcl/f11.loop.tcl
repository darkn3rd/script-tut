#!/usr/bin/tclsh
# count loop using while loop
set count 10
while {$count > 0} {
    puts "Count is $count"
    incr count -1
}
