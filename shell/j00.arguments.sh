#!/bin/sh
# test if user entered 2 values
if [ $# -lt 2 ]; then
  # print message if less than two numbers
  echo "You need to enter two numbers: \"$0\" num1 num2"
else
  # print summation of both arguments
  echo "The sum of $1 and $2 is: $(($1 + $2))"
fi