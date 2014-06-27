#!/bin/bash
let count=10                    # set initial state
# loop 10 to 1 with while/do...done construction
while (( $count > 0 )); do      # test if 0 reached
  echo "Count is $count"        # print curent count
  let count="$count - 1"        # decrement
done
