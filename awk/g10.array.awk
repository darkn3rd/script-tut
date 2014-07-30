#!/bin/awk -f
BEGIN {
  # build array
  # Note: awk doesn't have mechanism to build array in one line
  #  Thus, we use split function as a workaround for this limitation
  split("bob ed steve ralph joe deb kate", nicknames)
 
  # print out array item by item - can arrrive in any order
  print "The names are: "
  for (name in nicknames)
    print " " nicknames[name]
}
