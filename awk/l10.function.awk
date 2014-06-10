#!/bin/awk -f
function capitalize(string) 
{
  return toupper(string)      # return capitlized string
}
 
BEGIN {
  # call the function
  result = capitalize("ibm")  # pass string 

  # output results 
  print "The result of capitalization is: " result
}
