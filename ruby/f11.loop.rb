#!/usr/bin/ruby
answer = ""                               # default
# loop until user quits (while/do...end construct)
while answer != "quit" do
  print "Enter your name (quit to Exit): " # print prompt
  STDOUT.flush                            # flush buffer to show prompt
  answer = gets.chomp                     # get string input
 
  if answer != "quit"
      puts "Hello #{answer}"              # print if not exiting
  end
end