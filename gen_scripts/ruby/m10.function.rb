#!/usr/bin/env ruby

# create method (function)
def capitalize (string)
   string.upcase              # return fully uppercase string
end

# output string before calling method
string = "ibm"
puts "The current string is: \"#{string}\"."

# call the method (function)
result = capitalize(string)

# output results
puts "The capitalized string is: \"#{result}\"."
