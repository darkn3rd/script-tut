#!/bin/gawk -f
BEGIN {
  # acquire num of args and script name
  ARG_COUNT   = ARGC - 1 # get num of arguments
  SCRIPT_NAME = ARGV[0]  # get script name
  EX_USAGE        = 64   # status for command line usage error
  EX_OK           = 0    # status for successful termination

  if (ARG_COUNT != 1) {
    # output usage statement to standard error
    printf "\nYou need to enter two numbers: \n\n" > "/dev/stderr"
    printf "   Usage: %s [num1] [num2]\n\n", SCRIPT_NAME > "/dev/stderr"
  } else {
    sum = ARGV[1] + ARGV[2]; # get sum of both arguments
    # print results of both arguments and summation
    printf "The sum of %d and %d is: %d\n", ARGV[1], ARGV[2], sum
  }
}
