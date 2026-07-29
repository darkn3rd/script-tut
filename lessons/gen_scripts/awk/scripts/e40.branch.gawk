#!/usr/bin/env gawk -f
BEGIN {
  # a "\"-continued chain of adjacent string literals, assigned to one
  #  variable in a single statement - the same multi-line technique as
  #  a22.output.awk, just saved to "menu" first instead of being passed
  #  straight to printf. See e41.branch.gawk for the alternate technique
  #  of building the menu piece by piece via repeated concatenation.
  # switch/case is a gawk extension, not POSIX awk - hence .gawk, same
  #  as e41.branch.gawk.
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
