#!/usr/bin/env ruby

arg_count   = ARGV.length # get num of args
script_name = $0          # get script name

# check for only 2 arguments
if arg_count != 2 then
   # output usage statement to standard error
   $stderr.puts "\nYou need to enter two numbers: \n\n"
   $stderr.puts "   Usage: #{script_name} [num1] [num2]\n\n" 
else
   # get sum of both arguments, force cast them to integer
   sum = ARGV[0].to_i + ARGV[1].to_i
   # print results of both arguments (string) and summation (integer)
   puts "The sum of #{ARGV[0]} and #{ARGV[1]} is: #{sum}"
end
