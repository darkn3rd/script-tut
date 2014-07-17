#!/bin/bash
# create function (subroutine) 
function capitalize {
  # print fully uppercase string
  if (( $(echo ${BASH_VERSION} | cut -d. -f1) < 4 )); then
	echo ${1} | tr '[:lower:]' '[:upper:]' # Mac OS X way (pre Bash 4.x)
  else
	echo "${1^^}" 	                       # Bash 4.x way
  fi
}

# call function in subshell, capture result from stdout
result=$(capitalize ibm)
# output result
echo "The result of summation is: $result"

