#!/usr/bin/env bash
# save a menu string to output to user
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

read -p "$MENU" selection  # prompt user and get input
selection=${selection:0:1} # substring for only 1st char

# test selection to matching number
case "$selection" in
  1) echo "You selected a Coffee";;
  2) echo "You selected an Espresso";;
  3) echo "You selected a Latte";;
  4) echo "You selected a Machiato";;
  5) echo "You selected a Capucino";;
  6) echo "You selected a Mocha";;
  7) echo "You selected a Tea";;
  *) echo "You have not entered a valid selection";;
esac