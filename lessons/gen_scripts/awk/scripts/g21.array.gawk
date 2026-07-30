#!/usr/bin/env -S gawk -f
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
  #  Note: split() always starts array indices at 1, so display count-1
  #  to present the list as zero-indexed
  for (count = 1; count <= max; count++)
    print " nicknames[" count-1 "]=" nicknames[count]
}
