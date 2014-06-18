#!/bin/sh
# illustrative variables
arg_count=$#           # get number of arguments
# utility variables
output=""
  
echo "The arugments passed are:"
#  iterative style loop with range to enumerate list
for count in $(seq 1 $arg_count); do
  arg=$1                    # get arg from first positional
  # build ouput string by prepending previous result
  output="  item $count: $arg\n$output" 
  shift                             # shift positionals by one
done

# output resulting compiled string
echo "$output"