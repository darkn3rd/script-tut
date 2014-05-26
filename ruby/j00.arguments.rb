#!/usr/bin/ruby

if ARGV.length != 2 then
 puts "You need to enter two numbers: #{$0} num1 num2"
else
 puts "The sum of #{ARGV[0]} and #{ARGV[1]} is: #{ARGV[0].to_i + ARGV[1].to_i}"
end
