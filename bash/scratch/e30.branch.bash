#!/bin/bash
selection=1

# test using arithmentic expression
if (( $selection == 1 )); then
  echo "You selected a Coffee"
elif (( $selection == 2 )); then
  echo "You selected an Espresso"
elif (( $selection == 3 )); then
  echo "You selected a Latte"
elif (( $selection == 4 )); then
  echo "You selected a Machiato"
elif (( $selection == 5 )); then
  echo "You selected a Capucino"
elif (( $selection == 6 )); then
  echo "You selected a Mocha"
elif (( $selection == 7 )); then
  echo "You selected a Tea"
else
  echo "You have not entered a valid selection"
fi
