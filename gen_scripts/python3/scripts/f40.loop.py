#!/usr/bin/env python3
import re
# spin loop as always true condition
while True:
  # print a prompt and get answer
  answer = input("Enter your name (quit to exit): ")

  # skip loop if user enters an empty string
  if re.compile(r"^[\s\t]*$").match(answer):
    continue                   # skip to next loop

  # determine if user wants to exit loop
  if answer == "quit":
    break                      # exit loop if user wants to quit

  print("Hello %s!" % answer)  # output result as we are not exiting
