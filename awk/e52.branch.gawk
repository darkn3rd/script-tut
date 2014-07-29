#!/bin/gawk -f
BEGIN {
  printf "Input a character: "
  getline keypress
 
  # multiway test on character
  # NOTE: This is supported in Gawk 4.0 and above
  switch (keypress) {
    case /[[:lower:]]/:
       print "Lowercase letter"
       break
    case /[[:upper:]]/:
       print "Uppercase letter"
       break
    case /[[:digit:]]/:
       print "Digit"
       break
    default:
       print "Punctuation, whitespace, or other"
  }
}
