#!/bin/ksh
let count=10                    # set initial state

# use conditional loop
while (( $count > 0 )); do # test if 0 reached
  print "Count is $count"  # print curent count
  let count="$count - 1"   # decrement
done
