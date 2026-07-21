#!/usr/bin/env awk -f
BEGIN {
  # build array
  # Note: awk doesn't have mechanism to build array in one line
  #  Thus, we use split function as a workaround for this limitation
  split("bob ed steve ralph joe deb kate", nicknames)

  # print out array item by item
  print "The names are: "
  max = array_length(nicknames)     # save length for efficiency
  # count style loop to record index
  #  Note: split() always starts array indices at 1, so display count-1
  #  to present the list as zero-indexed
  for (count = 1; count <= max; count++)
    print " nicknames[" count-1 "]=" nicknames[count]
}

# ==================== HELPER FUNCTIONS ==================== #
# Helper Functions as POSIX Awk has no method to get size of array

# **************************************
# array_length() - returns length of array
#   Note: required as length() only works on strings in POSIX awk
#   Note: not needed with gawk 3.1.5 and 4.x as length works on
#    array as well
# **************************************
function array_length (array)
{
   count = 0                   # set initial counter value
   for (i in array) count++    # increment counter
   return count                # return count of last item
}
