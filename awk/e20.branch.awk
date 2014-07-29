#!/bin/awk -f
BEGIN {
  # prompt user and get input
  printf "Input a number: "
  getline number
 
  # test number range
  if (number > 0)
    print "Number is greater than 0"
  else if (number < 0)
    print "Number is less than 0"
  else
    print "Number is 0"
}
