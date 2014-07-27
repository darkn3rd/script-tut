#!/bin/awk -f
BEGIN {
  # build array
  # Note: awk doesn't have mechanism to build array in one line
  #  Thus, we use split function as a workaround for this limitation
  split("bob ed steve ralph joe deb kate", nicknames)
 
  # print out array item by item
  print "The names are: "
  max = array_length(nicknames)     # save length for efficiency
  # count style loop to record index
  for (count = 1; count <= max; count++) 
    print "  nicknames[" count "] = " nicknames[count]
}

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
