#!/bin/tcsh
# test for 2 arguments
if ($#argv != 2) then
  # print friendly message
  echo "You need to enter two numbers: "  
  echo "   Usage: $0 num1 num2"
else
  # print sum of two integer arguments
  @ sum = $argv[1] + $argv[2]
  echo "The sum of $argv[1] and $argv[2] is $sum"
endif

