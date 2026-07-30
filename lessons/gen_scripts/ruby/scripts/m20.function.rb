#!/usr/bin/env ruby

# create method (function) - returns a real Array object directly
def sort_array (array)
   array.sort   # return sorted array (last expression is the return value)
end

# initialize initial array
array = ["bob", "ed", "steve", "ralph", "joe", "deb", "kate"]
# output current list before calling function
puts "Current names are: #{array.join(", ")}"

# call the method (function)
result = sort_array(array)

# output the result
puts "Sorted names are: #{result.join(", ")}"
