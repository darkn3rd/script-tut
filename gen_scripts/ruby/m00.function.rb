#!/usr/bin/env ruby

# create method (function)
def addNums (*numbers)
   sum = 0                          # initialize starting sum value
   numbers.each {|num| sum += num } # iterate and sum up nums
   sum                              # return value
end

numbers = [5, 2, 4, 3, 6]
# output numbers before function
puts "The numbers to be added are #{numbers.join(", ")}."

# call the method (function)
result = addNums(*numbers)

# output results
puts "The result of their summation is: #{result}."
