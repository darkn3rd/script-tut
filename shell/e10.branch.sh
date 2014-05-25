#!/bin/sh
echo -n "Input a character: " ; read Keypress
 
# case construction
case "$Keypress" in
  [[:lower:]]   ) echo "Lowercase letter";;
  [[:upper:]]   ) echo "Uppercase letter";;
  [[:digit:]]   ) echo "Digit";;
  *             ) echo "Punctuation, whitespace, or other";;
esac