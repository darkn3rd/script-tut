#!/usr/bin/env tcsh
# test for 2 arguments
if ($#argv != 2) then
  # output usage statement to standard error
  printf "\nYou need to enter two numbers: \n\n"  > /dev/stderr
  printf "   Usage: $0 [num1] [num2]\n\n" > /dev/stderr
else
  # print sum of two integer arguments
  @ sum = $argv[1] + $argv[2]
  echo "The sum of $argv[1] and $argv[2] is $sum"
endif
