#!/usr/bin/env pash
# build a menu string to output to user
$menu = @"
Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

Make your selection
"@
 
# get user input 
$selection = Read-Host $menu

# test $selection to matching number using string comparison
if ($selection -eq "1") {
   "You selected a Coffee"
} elseif ($selection -eq "2") {
   "You selected an Espresso"
} elseif ($selection -eq "3") {
   "You selected a Latte"
} elseif ($selection -eq "4") {
   "You selected a Machiato"
} elseif ($selection -eq "5") {
   "You selected a Capucino"
} elseif ($selection -eq "6") {
   "You selected a Mocha"
} elseif ($selection -eq "7") {
   "You selected a Tea"
} else {
   "You have not entered a valid selection"
}