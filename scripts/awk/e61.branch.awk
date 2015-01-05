#!/usr/bin/env awk -f
BEGIN {
  printf "Input a character: "   # prompt for input
  getline keypress               # grab input

  # Use POSIX Character Class for i18n
  if (keypress ~ /[[:lower:]]/)
    print "Lowercase letter"
  else if (keypress ~ /[[:upper:]]/)
    print "Uppercase letter"
  else if (keypress ~ /[[:digit:]]/)
    print "Digit"
  else
    print "Punctuation, whitespace, or other"
}
