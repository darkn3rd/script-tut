#!/bin/gawk -f
BEGIN {
  # build array
  # Note: awk doesn't have mechanism to build array in one line
  #  Thus, we use split function as a workaround for this limitation
  split("bob ed steve ralph joe deb kate", nicknames)
 
  # print out array item by item
  print "The names are: "

  # save length for efficiency
  max = length(nicknames)          # Note: Only works in Gawk 3.1.5 and above

  # count style loop to record index
  for (count = 1; count <= max; count++) 
    print "  nicknames[" count "] = " nicknames[count]
}
