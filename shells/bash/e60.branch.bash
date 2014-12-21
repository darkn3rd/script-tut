#!/bin/bash
read -p "Input a character: " keypress # prompt & get input
keypress=${keypress:0:1}               # substring for only 1st char
 
# test if keypress matches pattern
if [[ $keypress = [a-z] ]]; then
  echo "Lowercase letter"
elif [[ $keypress = [A-Z] ]]; then
  echo "Uppercase letter"
elif [[ $keypress = [0-9] ]]; then
  echo "Digit"
else
  echo "Punctuation, whitepace, or other"
fi
