#!/usr/bin/tclsh
# for loop w/ counter
for {set count 10} {$count > 0} {incr count -1} {
  puts "Count is $count"
}
