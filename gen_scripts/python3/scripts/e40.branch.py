#!/usr/bin/env python3
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

# multiway branch using match/case (Python 3.10+) - see e30/e31.branch.py
#  for the if/elif equivalent
match selection:
  case 1:
    print("You selected a Coffee")
  case 2:
    print("You selected an Espresso")
  case 3:
    print("You selected a Latte")
  case 4:
    print("You selected a Machiato")
  case 5:
    print("You selected a Capucino")
  case 6:
    print("You selected a Mocha")
  case 7:
    print("You selected a Tea")
  case _:
    print("You have not entered a valid selection")
