#!/usr/bin/env bash
read -p "Input a character: " keypress # prompt user and get input
keypress=${keypress:0:1}               # substring for only 1st char
 
# case construction
case "$keypress" in
  [a-z] ) echo "Lowercase letter";;
  [A-Z] ) echo "Uppercase letter";;
  [0-9] ) echo "Digit";;
            * ) echo "Punctuation, whitespace, or other";;
esac
