#!/usr/bin/ruby

# create method (function)
def add (*numbers)
   sum = 0                          # initialize starting sum value
   numbers.each {|num| sum += num } # iterate and sum up nums
   sum                              # return value
end

# call the method (function)
result = add 5, 2, 4, 3, 6

# output results
puts "The result of summation is: #{result}"