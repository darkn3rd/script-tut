#!/bin/awk -f
# create function
function capitalize(string) 
{
  return toupper(string)      # return capitlized string
}
 
BEGIN {
  # call the function
  result = capitalize("ibm")  # pass string 

  # output results with resulitng string
  print "The result of capitalization is: " result
}
