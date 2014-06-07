#!/bin/awk -f
BEGIN {
  printf "Input a character: "
  getline keypress
 
  if (keypress ~ /[[:lower:]]/)
    print "Lowercase letter"
  else if (keypress ~ /[[:upper:]]/)
    print "Uppercase letter"
  else if (keypress ~ /[[:digit:]]/)
    print "Digit"
  else
    print "Punctuation, whitespace, or other"
}
