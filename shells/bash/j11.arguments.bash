#!/usr/bin/env bash
# illustrative variables
ARG_COUNT=$#         # get number of arguments

echo "The arugments passed are:"
#  count style loop with range to generate sequence of numbers
#   Note: Bash only accepts raw static numbers, so eval needed
for count in $(eval echo {1..$ARG_COUNT}); do
  arg=$1                    # get arg from first positional
  echo " item $count: $arg" # output count and arg
  shift                     # shift positionals by one
done