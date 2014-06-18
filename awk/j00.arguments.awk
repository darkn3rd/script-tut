#!/bin/awk -f
BEGIN {
  # acquire num of args and script name
  arg_count   = ARGC - 1;   # get num of arguments
  script_name = ARGV[0];    # get script name

  if (arg_count != 2) {
    printf "\nYou need to enter two numbers: \n\n"
    printf "   Usage: %s [num1] [num2]\n\n", script_name
  } else {
    sum = ARGV[1] + ARGV[2]; # get sum of both arguments
    # print results of both arguments and summation
    printf "The sum of %d and %d is: %d\n", ARGV[1], ARGV[2], sum
  }
}
