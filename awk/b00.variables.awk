#!/usr/bin/env awk -f
BEGIN {
  # declare variables
  num    = 5
  char   = "a"
  string = "This is a string"

  # output values using string concatenation
  print "Number is " num "."
  print "Character is '" char "'."
  print "String is \"" string "\"."
}
