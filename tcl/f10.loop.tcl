#!/usr/bin/tclsh
# count loop using general loop construct
for {set count 10} {$count > 0} {incr count -1} {
  puts "Count is $count"
}
