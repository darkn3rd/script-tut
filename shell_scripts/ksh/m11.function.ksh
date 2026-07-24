#!/usr/bin/env ksh
# create function (subroutine) 
function capitalize {
  typeset -u string=$1  # create uppercase only variable
  print $string         # output result
}

string="ibm"
print "The current string is: \"$string\"."

# call function in subshell, capture result from stdout
result=$(capitalize "$string")
# output result
print "The capitalized string is: \"$result\"."
