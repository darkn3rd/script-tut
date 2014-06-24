#!/usr/bin/python
# spin loop as always true condition
#   break to exit from loop
while True:
  # print a prompt and get answer
  answer = raw_input("Enter your name (quit to Exit): ")
  if answer == "quit":
    break                      # exit loop as user wants to quit
  else:
    print "Hello %s!" % answer # output result as we are not exiting