#!/bin/sh
# illustrative variables
script_name=$0  # get name of script
arg_count=$#    # get number of arguments

# test if user entered 2 values
if [ $arg_count -ne 2 ]; then
  # print message if less than two numbers
  echo "You need to enter two numbers: \"$script_name\" num1 num2"
else
  # print summation of both arguments
  echo "The sum of $1 and $2 is: $(($1 + $2))"
fi
