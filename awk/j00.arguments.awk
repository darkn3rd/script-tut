#!/bin/awk -f
BEGIN {
  # acquire num of args and script name
  arg_count   = ARGC - 1;  # get num of arguments
  script_name = ARGV[0];   # get script name

  if (arg_count != 2)
    printf "You need to enter two numbers: \"%s\" num1 num2\n", script_name
  else
    printf "The sum of %d and %d is: %d\n", ARGV[1], ARGV[2], ARGV[1] + ARGV[2]
}
