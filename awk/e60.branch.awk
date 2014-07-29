#!/bin/awk -f
BEGIN {
  printf "Input a character: "   # prompt for input
  getline keypress               # grab input

  # Use ASCII Character Class (only English)
  if (keypress ~ /[a-z]/)
    print "Lowercase letter"
  else if (keypress ~ /[A-Z]/)
    print "Uppercase letter"
  else if (keypress ~ /[0-9]/)
    print "Digit"
  else
    print "Punctuation, whitespace, or other"
}
