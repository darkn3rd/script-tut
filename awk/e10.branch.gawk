#!/bin/gawk -f
BEGIN {
  printf "Input a character: "
  getline keypress
 
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
