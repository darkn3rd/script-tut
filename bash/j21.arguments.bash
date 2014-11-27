#!/bin/bash
# illustrative variables
ARG_COUNT=$#           # get number of arguments
# utility variables
output=""

echo "The arugments passed are (reverse order):"
#  count style loop with range to enumerate list
for count in $(eval echo {1..$ARG_COUNT}); do
  arg=$1  # get arg from first positional
  # build ouput string by prepending previous result
  output="  item $count: $arg\n$output"
  shift   # shift positionals by one
done

# output resulting compiled string
printf "$output"
