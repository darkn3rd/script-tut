#!/usr/bin/env gawk -f
BEGIN {
  # build a menu string to output to user
  menu = "Select an item from the menu.\n"
  menu = menu "\n  1 - Coffee"
  menu = menu "\n  2 - Espresso"
  menu = menu "\n  3 - Latte"
  menu = menu "\n  4 - Machiato"
  menu = menu "\n  5 - Capucino"
  menu = menu "\n  6 - Mocha"
  menu = menu "\n  7 - Tea"
  menu = menu "\n\nMake your selection: "

  # get user output
  printf menu        # output menu and prompt
  getline selection  # get input

  # multiway test on selection to matching number using numerical comparison
  switch (selection) {
    case 1:  print "You selected a Coffee";    break
    case 2:  print "You selected an Espresso"; break
    case 3:  print "You selected a Latte";     break
    case 4:  print "You selected a Machiato";  break
    case 5:  print "You selected a Capucino";  break
    case 6:  print "You selected a Mocha";     break
    case 7:  print "You selected a Tea";       break
    default: print "You have not entered a valid selection"
  }

}
