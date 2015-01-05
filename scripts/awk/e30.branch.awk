#!/usr/bin/env awk -f
BEGIN {
  # build a menu string to output to user
  menu = "\nSelect an item from the menu."
  menu = menu "\n   1 - Coffee"
  menu = menu "\n   2 - Espresso"
  menu = menu "\n   3 - Latte"
  menu = menu "\n   4 - Machiato"
  menu = menu "\n   5 - Capucino"
  menu = menu "\n   6 - Mocha"
  menu = menu "\n   7 - Tea"
  menu = menu "\n\nMake your selection : "

  # get user output
  printf menu        # output menu and prompt
  getline selection  # get input

  # test selection to matching number using numerical comparison
  if (selection == 1) {
    print "You selected a Coffee"
  } else if (selection == 2) {
    print "You selected an Espresso"
  } else if (selection == 3) {
    print "You selected a Latte"
  } else if (selection == 4) {
    print "You selected a Machiato"
  } else if (selection == 5) {
    print "You selected a Capucino"
  } else if (selection == 6) {
    print "You selected a Mocha"
  } else if (selection == 7) {
    print "You selected a Tea"
  } else {
    print "You have not entered a valid selection"
  }

}
