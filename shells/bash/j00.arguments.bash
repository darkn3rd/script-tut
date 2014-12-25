#!/usr/bin/env bash
# illustrative variables
SCRIPT_NAME=$0  # get name of script
ARG_COUNT=$#    # get number of arguments

# test if user entered 2 values
if (( $ARG_COUNT != 2 )); then
  # output usage statement to standard error
  printf "\nYou need to enter two numbers: \n\n" >&2
  printf "   Usage: $SCRIPT_NAME [num1] [num2]\n\n" >&2
else
  sum=$(($1 + $2))  # get sum of both arguments
  # print results of both arguments and summation
  echo "The sum of $1 and $2 is: $sum"
fi
