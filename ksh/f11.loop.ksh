#!/bin/ksh
let count=10                    # set initial state

# use count style loop with while 
while (( $count > 0 )); do
  print "Count is $count"  # print curent count
  let count="$count - 1"   # decrement
done
