#!/usr/bin/env bash
# create function (subroutine) 
function capitalize {
  # print fully uppercase string
  if (( $(echo ${BASH_VERSION} | cut -d. -f1) < 4 )); then
	echo ${1} | tr '[:lower:]' '[:upper:]' # Mac OS X way (pre Bash 4.x)
  else
	echo "${1^^}" 	                       # Bash 4.x way
  fi
}

string="ibm"
echo "The current string is: \"$string\"."

# call function in subshell, capture result from stdout
result=$(capitalize "$string")
# output result
echo "The capitalized string is: \"$result\"."

