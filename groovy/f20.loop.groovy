#!/usr/bin/env groovy
answer = ""  # required to initialize answer before testing it

# conditonal loop with while
while answer != "quit":
  # output a prompt and get answer
  answer = raw_input("Enter your name (quit to Exit): ")
  # output answer if not quitting
  if answer != "quit":
    print "Hello %s!" % answer  # output results if not exiting
