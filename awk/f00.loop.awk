#!/bin/awk -f
BEGIN {
  # count loop using for
  for ( count = 10; count > 0; count-- )
    print "count is " count
}
