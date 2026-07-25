#!/usr/bin/env bash
# count style loop using generated sequence 
#   that is fed into collection loop construct
for count in {10..1}; do
  echo "Count is $count"        # print curent count
  let count="$count - 1"        # decrement
done
