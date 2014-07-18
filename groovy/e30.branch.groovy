#!/usr/bin/env groovy
import sys  # system library for standard input and output

# build a menu string to output to user
menu = """\
Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

Make your selection: """
 
# get user output 
sys.stdout.write(menu)              # output menu and prompt
selection = int(sys.stdin.read(1))  # read one number

# NOTE: This explicitly uses integers to illustrate comparing numbers
#  However, if user enters a non-integer, script will halt.

# test selection to matching number
if selection == 1:
  print "You selected a Coffee"
elif selection == 2:
  print "You selected an Espresso"
elif selection == 3:
  print "You selected a Latte"
elif selection == 4:
  print "You selected a Machiato"
elif selection == 5:
  print "You selected a Capucino"
elif selection == 6:
  print "You selected a Mocha"
elif selection == 7:
  print "You selected a Tea"
else:
  print "You have not entered a valid selection"
