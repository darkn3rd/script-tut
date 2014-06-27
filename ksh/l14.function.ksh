#!/bin/ksh

# Testing:
#  - works on Mac OS X 10.8.5

# create function (subroutine) 
function capitalize {
  print $1 | perl -ne 'print uc($_);' # print fully uppercase string
}

# call function in subshell, capture result from stdout
result=$(capitalize ibm)
# output result
print "The result of summation is: $result"