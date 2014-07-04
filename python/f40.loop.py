#!/usr/bin/python
import re
# spin loop as always true condition
#   break to exit from loop
#   continue to skip when there is no input
while True:
  # print a prompt and get answer
  answer = raw_input("Enter your name (quit to Exit): ")
  # skip loop if user enters an empty string
  if re.compile("^[\s\t]*$").match(answer):
    continue
  if answer == "quit":
    break                      # exit loop if user wants to quit
  print "Hello %s!" % answer   # output result as we are not exiting