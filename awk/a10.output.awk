#!/bin/awk -f
BEGIN {
  print "This is a test of the emergency script system."\
        "  This is only a test" > "/dev/stderr"
}
