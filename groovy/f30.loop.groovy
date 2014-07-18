#!/usr/bin/env groovy
# spin loop as always true condition
while True:
  # print a prompt and get answer
  answer = raw_input("Enter your name (quit to Exit): ")
  
  # determine if user wants to exit loop
  if answer == "quit":
    break                      # exit loop as user wants to quit

  print "Hello %s!" % answer   # output result as we are not exiting
