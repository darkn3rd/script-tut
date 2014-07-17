# output a menu string to output to user
cat <<< '
Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

Make your selection: '                  # output menu and prompt

read -p "Input a character: " selection # prompt user and get input
selection=${selection:0:1}              # substring for only 1st char

# test selection to matching number
if [[ selection -eq 1 ]]; then
  echo "You selected a Coffee"
elif [[ selection -eq 2 ]]; then
  echo "You selected an Espresso"
elif [[ selection -eq 3 ]]; then
  echo "You selected a Latte"
elif [[ selection -eq 4 ]]; then
  echo "You selected a Machiato"
elif [[ selection -eq 5 ]]; then
  echo "You selected a Capucino"
elif [[ selection -eq 6 ]]; then
  echo "You select a Mocha"
elif [[ selection -eq 7 ]]; then
  echo "You selected a Tea"
else
  echo "You have not entered a valid selection"
fi