#!/usr/bin/env bash
# illustrative variables
ARG_COUNT=$#     # get number of arguments
# utility variables
count=1          # initialize counter
output=""        # initialize empty output string

echo "The arguments passed are (reverse order):"
#  count style loop to enumerate args
while (( $count <= $ARG_COUNT )); do # loops while count is 1 or higher
  arg=$1                             # save argument from positional parameter
  # build ouput string by prepending previous result
  output="  item $count: $arg\n$output"
  count=$(( $count + 1 ))            # decrement counter
  shift                              # shift positionals by one
done

# output resulting compiled string
printf "$output"
