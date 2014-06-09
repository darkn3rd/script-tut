#!/bin/awk -f

# **************************************
# array_length() - returns length of array
#   Note: required as length() only works on strings in gawk 3.x
#    and POSIX awk
# **************************************
function array_length (array) {
  count = 0                   # set initial counter value
  for (i in array) count++    # increment counter
  return count                # return count of last item
}

# **************************************
# join (array, sep) - returns string given array and seperator
#   Helper function to help enumerate a list easily
# **************************************
function join(array, sep)
{
    result = array[0]
    end    = array_length(array)
 
    for (i = 1; i < end; i++) {
        result = result sep array[i]
    }
 
    return result
}
 
# **************************************
#   Main Section
# **************************************
BEGIN {
  # build array item by item
  nicknames[0]="bob"
  nicknames[1]="ed"
  nicknames[2]="steve"
  nicknames[3]="ralph"
  nicknames[4]="joe"
  nicknames[5]="deb"
  nicknames[6]="kate"
 
  # print number of elements
  print  "The number of nicknames is: " array_length(nicknames)

  # print all of elements in one line
  printf "The nicknames are: " join(nicknames, ", ") "\n"
}
