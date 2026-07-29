#!/usr/bin/env zsh
# create function (subroutine)
# bash's version-detection dance (tr fallback vs "${1^^}") doesn't apply
#  here at all - $BASH_VERSION is unset under zsh (making the arithmetic
#  test itself a "bad math expression"), and "${1^^}" is a bash 4-only
#  expansion zsh doesn't have ("bad substitution"). zsh's own "(U)"
#  parameter flag does the uppercase conversion directly.
function capitalize {
  echo "${(U)1}"
}

string="ibm"
echo "The current string is: \"$string\"."

# call function in subshell, capture result from stdout
result=$(capitalize "$string")
# output result
echo "The capitalized string is: \"$result\"."

