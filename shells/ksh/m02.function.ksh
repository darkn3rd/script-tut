#!/bin/ksh
# create function (subroutine) 
function add {
  sum=0                     # initialize starting sum value
  for num in "$@"; do       # iterate through parameters
    sum=$(( $sum + $num ))  # add num to sum
  done
 
  result=$sum               # outer scope result set to $sum
}

# call function and use side-effect 
add 5 2 4 3 6
# output result
print "The result of summation is: $result"