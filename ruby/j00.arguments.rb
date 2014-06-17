#!/usr/bin/ruby

arg_count   = ARGV.length # get num of args
script_name = $0          # get script name

# check for only 2 arguments
if arg_count != 2 then
 # print helpful instructions 
 puts "You need to enter two numbers: #{script_name} num1 num2"  
else
 # print sum pf two integer arguments
 puts "The sum of #{ARGV[0]} and #{ARGV[1]} is: #{ARGV[0].to_i + ARGV[1].to_i}"
end
