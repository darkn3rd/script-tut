#!/usr/bin/ruby

# create method (subroutine)
def add (*numbers)
   sum = 0
   numbers.each {|num| sum += num } # iterate and sum up nums
   puts "The summation is: #{sum}"
end

# call the method (subroutine)
add 5, 2, 4, 3, 6
