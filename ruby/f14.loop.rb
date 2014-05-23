#!/usr/bin/ruby
# loop until user quits (spin loop style)
loop do
  print "Enter you name (quit to Exit): " # print prompt
  STDOUT.flush                            # flush buffer to show prompt
  answer = gets.chomp                     # get string input
 
  if answer.chomp == "quit"               # check for exit
      break                               # exit loop
  else
      puts "Hello #{answer}"              # print result if not exiting
  end
end