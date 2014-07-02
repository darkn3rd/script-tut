#!/bin/ksh
# illustrative variables
script_name=$0  # get name of script
arg_count=$#    # get number of arguments

# test if user entered 2 values
if (( $arg_count != 2 )); then
  # print message if less than two numbers
  print -u2 "\nYou need to enter two numbers: \n"
  print -u2 "   Usage: $script_name [num1] [num2]\n"
else
  sum=$(($1 + $2))  # get sum of both arguments
  # print results of both arguments and summation
  print "The sum of $1 and $2 is: $sum"
fi