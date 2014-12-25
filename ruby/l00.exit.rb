#!/usr/bin/env ruby
# illustrative variables
arg_count    = ARGV.length # get num of args
@script_name = $0          # get script name
EX_USAGE     = 64          # status for command line usage error
EX_OK        = 0           # status for successful termination

# **************************************
# add_nums: Output summation of all numbers passed by caller.
#
# numbers  - The Array of numbers to be processed
# **************************************
def add_nums (numbers)
   sum = 0                               # initialize starting sum value
   numbers.each {|num| sum += num.to_i } # sum up nums
   puts "The summation is: #{sum}"       # output results
end

# **************************************
# usage_message: Output instructions to utilize script to standard error
#   and then exit program with appropriate POSIX error code.
# **************************************
def usage_message ()
  # output usage statement to standard error
  $stderr.puts "\nYou need to enter one or more numbers: \n\n"
  $stderr.puts "   Usage: #{@script_name} [num1] [num2] [num3]...\n\n"

  # exit program with appropriate error code
  exit EX_USAGE
end

# **************************************
#             main section 
# **************************************
if arg_count < 1 then
   usage_message
else
   add_nums ARGV
end

# exit program with success (default behavior)
exit EX_OK