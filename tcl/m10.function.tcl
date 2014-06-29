#!/usr/bin/tclsh

# create function that returns string output
proc capitalize {string} { 
  return [string toupper $string]
}

# call function with variable number of parameters
set result [capitalize "ibm"]
puts "The result of capitalization is: $result."

