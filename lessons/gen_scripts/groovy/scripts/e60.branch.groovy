#!/usr/bin/env groovy
print "Input a character: "          // output prompt
keypress  = (char) System.in.read()  // get input of one character

// test keypress for matching pattern
if (keypress =~ "[a-z]")
  println "Lowercase letter"
else if (keypress =~ "[A-Z]")
  println "Uppercase letter"
else if (keypress =~ "[0-9]")
  println "Digit"
else
  println "Punctuation, whitespace, or other"
