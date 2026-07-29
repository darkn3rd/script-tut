#!/usr/bin/env ksh
# prompt user and get input
print -n "Input a number: "
read number

# test input and output result
if (( $number > 0 )); then
  print Number is greater than 0
elif (( $number < 0 )); then
  print Number is less than 0
else
  print Number is 0
fi
