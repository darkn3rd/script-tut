#!/usr/bin/env awk -f
BEGIN {
  count = 10      # initialize counter

  # count style loop using while construct
  while (count > 0) {
    print "Count is " count  # output count
    count--                  # decrement counter
  }

}
