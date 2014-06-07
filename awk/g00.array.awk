#!/bin/awk -f
# Join (array, sep) - returns string given array and seperator
#   Helper function to help enumerate a list easily
function join(array, sep)
{
    result = array[0]
    end    = length(array)
 
    for (i = 1; i <= end; i++) {
        sep = (i == end) ? "" : sep
        result = result sep array[i]
    }
 
    return result
}
 
BEGIN {
  nicknames[0]="bob"
  nicknames[1]="ed"
  nicknames[2]="steve"
  nicknames[3]="ralph"
  nicknames[4]="joe"
  nicknames[5]="deb"
  nicknames[6]="kate"
 
  # print number of elements
  print  "The number of nicknames is: " length(nicknames)
  # print all of elements in one line
  printf "The nicknames are: " join(nicknames, ", ") "\n"
}
