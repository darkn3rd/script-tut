#!/bin/sh

# create function (subroutine) 
add() {
  sum=0                     # initialize starting sum value
  for num in "$@"; do       # iterate through parameters
    sum=$(( $sum + $num ))  # add num to sum
  done
 
  result=$sum               # outer scop result set to $sum
}

# call function and use side-effect 
add 5 2 4 3 6
# output result
echo "The result of summation is: $result"