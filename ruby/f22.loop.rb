#!/usr/bin/env ruby
# conditional loop with begin...until construct
begin
  print "Enter your name (quit to Exit): " # print prompt
  STDOUT.flush                            # flush prompt to show prompt
  answer = gets.chomp                     # get string input
 
  if answer != "quit"
      puts "Hello #{answer}!"             # print if not exiting
  end
end until answer == "quit"