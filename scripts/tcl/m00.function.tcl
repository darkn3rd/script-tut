#!/usr/bin/env tclsh

# create function that returns integer output
proc addNums {args} {
  # local variables
  set sum 0          ;# initial sum value
  set nums $args     ;# friendlier name for arguments
  
  # add up all the num in nums array
  foreach num $nums { set sum [expr $sum + $num] }
  # output results of summation
  return $sum
}

# call function
set result [addNums 5 2 4 3 6]
puts "The result of summation is: $result."

