#!/usr/bin/env sh

# Testing:
#  - works on Mac OS X 10.8.5

# create function (subroutine) 
capitalize() {
  echo $1 | perl -ne 'print uc($_);' # print fully uppercase string
}

string="ibm"
echo "The current string is: \"$string\"."

# call function in subshell, capture result from stdout
result=$(capitalize "$string")
# output result
echo "The capitalized string is: \"$result\"."
