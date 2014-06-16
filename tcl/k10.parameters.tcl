#!/usr/bin/tclsh

# create subroutine supporting variable number of parameters
# NOTE: TCL requires the parameter to be called args
proc addNums {args} {
  # local variables
  set sum 0          ;# initial sum value
  set nums $args     ;# friendlier name for arguments
  
  # add up all the num in nums array
  foreach num $nums { set sum [expr $sum + $num] }
  # output results of summation
  puts "The sumation is: $sum" 
}

# call subroutine with variable number of parameters
addNums 5 2 4 3 6

