#!/usr/bin/env awk -f
BEGIN {
  # count loop using general loop construct
  for ( count = 10; count > 0; count-- )
    print "Count is " count      # output result
}
