#!/usr/bin/env tclsh

# create function that returns string output
proc capitalize {string} { 
  return [string toupper $string]
}

# output string before calling function
set string "ibm"
puts "The current string is: \"$string\"."

# call function with variable number of parameters
set result [capitalize $string]
puts "The capitalized string is: \"$result\"."

