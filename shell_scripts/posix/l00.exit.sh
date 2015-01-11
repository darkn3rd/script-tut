#!/usr/bin/env sh
SCRIPT_NAME=$0  # get name of script
ARG_COUNT=$#    # get number of arguments
EX_USAGE=64     # status for command line usage error
EX_OK=0         # status for successful termination

# output a usage message
usage_message() {
  # output usage statement to standard error
  printf "\nYou need to enter one or more numbers:\n\n" >&2
  printf "   Usage: $SCRIPT_NAME [num1] [num2] [num3]...\n\n" >&2

  return $EX_USAGE # return error code
}

# create subroutine with variable parameters
add_nums() {
  # add all the $num in @numbers list
  for num in "$@"; do sum=$(($sum + $num)); done
  # output results
  echo "The summation is: $sum"

  return $EX_OK  # return a success
}

# check for correct number of arguments
if [ $ARG_COUNT -lt 1 ]; then
  usage_message
else
  add_nums "$@"
fi

exit $?
