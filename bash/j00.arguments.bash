#!/bin/bash
# illustrative variables
script_name=$0  # get name of script
arg_count=$#    # get number of arguments

# test if user entered 2 values
if (( $arg_count != 2 )); then
  # output usage statement to standard error
  printf "\nYou need to enter two numbers: \n\n" >&2
  printf "   Usage: $script_name [num1] [num2]\n\n" >&2
else
  sum=$(($1 + $2))  # get sum of both arguments
  # print results of both arguments and summation
  echo "The sum of $1 and $2 is: $sum"
fi
