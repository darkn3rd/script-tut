#!/usr/bin/python
# while construction to prompt and exit
while True:
  answer = raw_input("Enter your name (quit to Exit): ")
  if answer == "quit":
    break
  else:
    print "Hello", answer