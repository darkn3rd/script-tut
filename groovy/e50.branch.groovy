#!/usr/bin/env groovy
print "Input a character: "          // output prompt
keypress  = (char) System.in.read()  // get input of one character

// multiway test on keypress on pattern
switch (keypress) {
  case ~/[a-z]/: println "Lowercase letter"; break
  case ~/[A-Z]/: println "Uppercase letter"; break
  case ~/[0-9]/: println "Digit";            break
  default: println "Punctuation, whitespace, or other"
}