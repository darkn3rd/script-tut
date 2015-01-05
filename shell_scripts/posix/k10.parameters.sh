#!/usr/bin/env sh
# create function (subroutine) 
add() {
  sum=0                       # initialize starting sum value
  for num in "$@"; do         # iterate through parameters
    sum=$(( $sum + $num ))    # add num to sum
  done
 
  echo The summation is: $sum # print report of summation
}

# call the function (subroutine) 
add 5 2 4 3 6