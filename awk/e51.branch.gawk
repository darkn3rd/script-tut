#!/bin/gawk -f
BEGIN {
  printf "Input a character: "
  getline keypress
 
  # multiway test on character
  # NOTE: This is supported in Gawk 4.0 and above
  switch (keypress) {
    case /[a-z]/:
       print "Lowercase letter"
       break
    case /[A-Z]/:
       print "Uppercase letter"
       break
    case /[0-9]/:
       print "Digit"
       break
    default:
       print "Punctuation, whitespace, or other"
  }
}
