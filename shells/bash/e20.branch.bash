#!/usr/bin/env bash
# prompt user and get input
read -p "Input a number: " number
# test input and output result
if (( $number > 0 )); then
  echo Number is greater than 0
elif (( $number < 0 )); then
  echo Number is less than 0
else
  echo Number is 0
fi
