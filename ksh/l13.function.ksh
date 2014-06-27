#!/bin/ksh

# Tested:
#   - does not work on Mac OS X 10.8.5

# create function (subroutine) 
function capitalize {
  # this requires GNU Sed or a sed that support \U
  print $1 | sed 's/.*/\U&/' # print fully uppercase string
}

# call function in subshell, capture result from stdout
result=$(capitalize ibm)
# output result
print "The result of summation is: $result"