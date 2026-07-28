#!/usr/bin/env zsh
# prompt user and get input
printf "%s" "Input a number: "
read number
# test input and output result
if (( $number > 0 )); then
  echo Number is greater than 0
elif (( $number < 0 )); then
  echo Number is less than 0
else
  echo Number is 0
fi
