#!/usr/bin/ruby
# loop until user quits (begin...while construct)
begin
  print "Enter your name (quit to Exit): " # print prompt
  STDOUT.flush                             # flush buffer to show prompt
  answer = gets.chomp                      # get string input
 
  if answer != "quit"
      puts "Hello #{answer}"               # print if not exiting
  end
end while answer != "quit"