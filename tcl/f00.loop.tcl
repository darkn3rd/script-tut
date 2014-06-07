#!/usr/bin/tclsh
# while loop w/ counter
set count 10
while {$count > 0} {
    puts "Count is $count"
    incr count -1
}
