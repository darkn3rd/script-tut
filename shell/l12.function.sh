#!/bin/sh

# Testing:
#  - works on Mac OS X 10.8.5

# create function (subroutine) 
capitalize() {
  echo $1 | awk '{print toupper($0)}' # print fully uppercase string
}

# call function in subshell, capture result from stdout
result=$(capitalize ibm)
# output result
echo "The result of summation is: $result"