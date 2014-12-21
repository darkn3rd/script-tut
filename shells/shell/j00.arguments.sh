#!/bin/sh
# illustrative variables
script_name=$0  # get name of script
arg_count=$#    # get number of arguments

# test if user entered 2 values
if [ $arg_count -ne 2 ]; then
  # print message if less than two numbers
  echo "\nYou need to enter two numbers: \n"
  echo "   Usage: $script_name [num1] [num2]\n"
else
  sum=$(($1 + $2))  # get sum of both arguments
  # print results of both arguments and summation
  echo "The sum of $1 and $2 is: $sum"
fi
