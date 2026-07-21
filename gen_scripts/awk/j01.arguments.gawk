#!/usr/bin/env gawk -f
BEGIN {
  # acquire num of args
  ARG_COUNT = ARGC - 1;   # get num of arguments

  # ARGV[0] is just "gawk", not the -f script name (gawk gives no direct
  #  variable for it). PROCINFO["argv"] is a gawk extension holding the
  #  full raw command line, so scan it for the argument after "-f".
  for (i = 0; i < length(PROCINFO["argv"]); i++) {
    if (PROCINFO["argv"][i] == "-f") {
      SCRIPT_NAME = PROCINFO["argv"][i+1]
      break
    }
  }

  if (ARG_COUNT != 2) {
    # output usage statement to standard error
    printf "\nYou need to enter two numbers:\n\n" > "/dev/stderr"
    printf "   Usage: %s [num1] [num2]\n\n", SCRIPT_NAME > "/dev/stderr"
  } else {
    sum = ARGV[1] + ARGV[2]; # get sum of both arguments
    # print results of both arguments and summation
    printf "The sum of %d and %d is: %d.\n", ARGV[1], ARGV[2], sum
  }
}
