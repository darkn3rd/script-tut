#!/bin/ksh
# create function (subroutine) 
function capitalize {
  typeset -u string=$1
  print $string
}

# call function in subshell, capture result from stdout
result=$(capitalize ibm)
# output result
print "The result of summation is: $result"