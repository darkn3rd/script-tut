#!/bin/sh

# create function (subroutine) 
add() {
  sum=0
  for num in "$@"; do
    sum=$(( $sum + $num ))
  done
 
  result=$sum
}

# call function in subshell, save result 
add 5 2 4 3 6

echo "The result of summation is: $result"