#!/bin/sh
# Add Function (subroutine) 
add() {
  sum=0
  for num in "$@"; do
    sum=$(( $sum + $num ))
  done
 
  echo The summation is: $sum
}
 
add 5 2 4 3 6