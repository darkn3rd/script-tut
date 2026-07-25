#!/usr/bin/env sh

# create function (subroutine) 
add() {
  sum=0                     # initialize starting sum value
  for num in "$@"; do       # iterate through parameters
    sum=$(( $sum + $num ))  # add num to sum
  done
 
  return $sum               # return error code that has sum
}

echo "The numbers to be added are 5, 2, 4, 3, 6."
# call function
add 5 2 4 3 6
# output result using error code
echo "The result of their summation is: $?."
