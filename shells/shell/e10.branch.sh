#!/bin/sh
printf "Input a character: " ; read Keypress
 
# case construction
#  with support for POSIX character class expressions
case "$Keypress" in
  [[:lower:]]   ) echo "Lowercase letter";;
  [[:upper:]]   ) echo "Uppercase letter";;
  [[:digit:]]   ) echo "Digit";;
  *             ) echo "Punctuation, whitespace, or other";;
esac
