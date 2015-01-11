#!/usr/bin/env ruby
# pure spin loop using continous loop construct
#   break is used to exit loop, next to skip loop
loop do
  print "Enter your name (quit to Exit): " # print prompt
  STDOUT.flush                            # flush buffer to show prompt
  answer = gets.chomp                     # get string input

  if answer =~ /^[\s\t]*$/
    next                                  # skip loop if not answer entered
  end

  if answer.chomp == "quit"
    break                                 # exit loop if user wants to quit
  end

  puts "Hello #{answer}!"                 # print result as not exiting
end
