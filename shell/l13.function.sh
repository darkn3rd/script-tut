#!/bin/sh

# Tested:
#   - does not work on Mac OS X 10.8.5

# create function (subroutine) 
capitalize() {
  # this requires GNU Sed or a sed that support \U
  echo $1 | sed 's/.*/\U&/' # print fully uppercase string
}

# call function in subshell, capture result from stdout
result=$(capitalize ibm)
# output result
echo "The result of summation is: $result"