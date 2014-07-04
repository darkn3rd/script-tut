#!/usr/bin/ruby

arg_count    = ARGV.length # get num of args
@script_name = $0          # get script name

# addNums method (subroutine)
def addNums (numbers)
   sum = 0                               # initialize starting sum value
   numbers.each {|num| sum += num.to_i } # sum up nums
   puts "The summation is: #{sum}"       # output results
end

# addNums method (subroutine)
def usage_message ()
  # output usage statement to standard error
  $stderr.puts "\nYou need to enter one or more numbers: \n\n"
  $stderr.puts "   Usage: #{@script_name} [num1] [num2] [num3]...\n\n"
end

# check for only 2 arguments
if arg_count < 1 then
   usage_message
else
   addNums(ARGV)
end

