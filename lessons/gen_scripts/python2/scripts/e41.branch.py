#!/usr/bin/env python2
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

sys.stdout.write(menu)              # output menu and prompt
selection = int(sys.stdin.read(1))  # read one number

# python 2 has no switch/match statement (match/case is python 3.10+,
#  see python3's e40 lesson) - a dict keyed by value is the idiomatic,
#  dependency-free stand-in for a multiway branch, same as e40.branch.pl
options = {
  1: "You selected a Coffee",
  2: "You selected an Espresso",
  3: "You selected a Latte",
  4: "You selected a Machiato",
  5: "You selected a Capucino",
  6: "You selected a Mocha",
  7: "You selected a Tea",
}

print options.get(selection, "You have not entered a valid selection")
