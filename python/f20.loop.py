#!/usr/bin/python
# conditonal loop with while
while True:
  answer = raw_input("Enter your name (quit to Exit): ")
  if answer == "quit":
    break
  else:
    print "Hello", answer