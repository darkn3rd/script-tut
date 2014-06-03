#!/usr/bin/ruby

# create method (subroutine)
def addNums (*numbers)
   sum = 0                          # initialize starting sum value
   numbers.each {|num| sum += num } # iterate and sum up nums
   puts "The summation is: #{sum}"  # output results
end

# call the method (subroutine)
addNums 5, 2, 4, 3, 6
