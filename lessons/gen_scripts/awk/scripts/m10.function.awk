#!/usr/bin/env -S awk -f
# create function
function capitalize(string)
{
  return toupper(string)      # return capitlized string
}

BEGIN {
  # output string before calling function
  string = "ibm"
  print "The current string is: \"" string "\"."

  # call the function
  result = capitalize(string)  # pass string

  # output results with resulting string
  print "The capitalized string is: \"" result "\"."
}
