#!/usr/bin/env ruby
# declare global variables ($ sigil) - visible everywhere, including inside methods
$pond     = 500 # pond contains some available fish
$captured = 0   # captured represents fish captured

# create method (subroutine) - mutates the shared globals directly
def fish
  $pond     -= 150 # subtract fish from global pond
  $captured += 150 # add to the fish captured
end

# output initial amount of fish in shared resource
puts "We have #{$pond} in this pond."

fish # get some fish
puts "Fishing from the main pond... We now have #{$pond} in the main pond."

fish # get some fish
puts "Fishing from the main pond... We now have #{$pond} in the main pond."

fish # get some fish
puts "Fishing from the main pond... We now have #{$pond} in the main pond."

# output result of fish captured from shared resource
puts "We now have a total of #{$captured} fish captured"
