#!/bin/bash

# create function (subroutine) 
function add {
  sum=0                     # initialize starting sum value
  for num in "$@"; do       # iterate through parameters
    sum=$(( $sum + $num ))  # add num to sum
  done
 
  return $sum               # return error code that has sum
}

# call function 
add 5 2 4 3 6
# output result using error code
echo "The result of summation is: $?"