#!/usr/bin/env ksh
# create a menu string to output to user
MENU='
Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

Make your selection: '
 
# get user output 
read selection?"$MENU"      # prompt and get input
selection=${selection:0:1}  # substring for only 1st char

# test each selection using a string comparison
if [[ $selection = "1" ]]; then
  echo "You selected a Coffee"
elif [[ $selection = "2" ]]; then
  echo "You selected an Espresso"
elif [[ $selection = "3" ]]; then
  echo "You selected a Latte"
elif [[ $selection = "4" ]]; then
  echo "You selected a Machiato"
elif [[ $selection = "5" ]]; then
  echo "You selected a Capucino"
elif [[ $selection = "6" ]]; then
  echo "You selected a Mocha"
elif [[ $selection = "7" ]]; then
  echo "You selected a Tea"
else
  echo "You have not entered a valid selection"
fi
