#!/usr/bin/env ruby
# pure spin loop using continous loop construct
#   break is used to exit loop
loop do
  print "Enter you name (quit to Exit): " # print prompt
  STDOUT.flush                            # flush buffer to show prompt
  answer = gets.chomp                     # get string input
 
  if answer.chomp == "quit"               # check for exit
      break                               # exit loop
  end

  puts "Hello #{answer}!"                 # print result as not exiting
end