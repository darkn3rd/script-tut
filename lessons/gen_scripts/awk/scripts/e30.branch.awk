#!/usr/bin/env awk -f
BEGIN {
  # a "\"-continued chain of adjacent string literals, assigned to one
  #  variable in a single statement - the same multi-line technique as
  #  a22.output.awk, just saved to "menu" first instead of being passed
  #  straight to printf. See e31.branch.awk for the alternate technique
  #  of building the menu piece by piece via repeated concatenation.
  menu = "Select an item from the menu.\n" \
         "\n" \
         "  1 - Coffee\n" \
         "  2 - Espresso\n" \
         "  3 - Latte\n" \
         "  4 - Machiato\n" \
         "  5 - Capucino\n" \
         "  6 - Mocha\n" \
         "  7 - Tea\n" \
         "\n" \
         "Make your selection: "

  # printf, not print: print always appends a trailing newline, but
  #  there must be none here before the answer is typed.
  printf menu
  getline selection

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
