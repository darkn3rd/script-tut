#!/usr/bin/env ruby
# declare pond as an ordinary (local) variable - a method's own locals are
#  isolated by default, so fish's "pond" below can never see or touch this one.
pond      = 500 # pond contains some available fish
$captured = 0   # must stay global; a method can't mutate an outer local

# create method (subroutine) - this "pond" is a brand-new local, unrelated
#  to the one above, no matter how many times fish is called
def fish
  pond       = 500 # local to this method only
  pond      -= 150 # subtract from the local pond (no effect outside)
  $captured += 150 # add to the fish captured
end

# output initial amount of fish in shared resource
puts "We have #{pond} in this pond."

fish # get some fish
puts "Fishing from a local pond... We now have #{pond} in the main pond."

fish # get some fish
puts "Fishing from a local pond... We now have #{pond} in the main pond."

fish # get some fish
puts "Fishing from a local pond... We now have #{pond} in the main pond."

# output result of fish captured from local resource
puts "We now have a total of #{$captured} fish captured"
