#!/bin/awk -f
BEGIN {
  count = 10      # initialize counter
  
  # count style loop using while construct
  while (count > 0) {
    print "count is " count  # output count
    count--                  # decrement counter
  }

}
