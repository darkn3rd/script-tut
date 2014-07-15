#!/usr/bin/python
import sys  # system library for standard input and output

# build a menu string to output to user
menu = """\
Select an item from the menu.

  A - Coffee
  B - Espresso
  C - Latte
  D - Machiato
  E - Capucino
  F - Mocha
  G - Tea

Make your selection: """
 
# get user output 
sys.stdout.write(menu)         # output prompt
selection = sys.stdin.read(1)  # read one character
# convert to uppercase if user entered lowercase
selection = selection.upper()            

# test on a single variable selection
if selection == "A":
  print "You selected a Coffee"
elif selection == "B":
  print "You selected an Espresso"
elif selection == "C":
  print "You selected a Latte"
elif selection == "D":
  print "You selected a Machiato"
elif selection == "E":
  print "You selected a Capucino"
elif selection == "F":
  print "You select a Mocha"
elif selection == "G":
  print "You selected a Tea"
else:
  print "You have not entered a valid selection"