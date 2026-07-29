#!/usr/bin/env perl -w
# declare package globals (no "my", so visible to every sub in this file)
our $pond     = 500; # pond contains some available fish
our $captured = 0;   # captured represents fish captured

# create subroutine
sub fish {
  $pond     -= 150; # subtract fish from the global pond
  $captured += 150; # add to the fish captured
}

# output initial amount of fish in shared resource
print "We have $pond in this pond.\n";

fish();                                                             # get some fish
print "Fishing from the main pond... We now have $pond in the main pond.\n";

fish();                                                             # get some fish
print "Fishing from the main pond... We now have $pond in the main pond.\n";

fish();                                                             # get some fish
print "Fishing from the main pond... We now have $pond in the main pond.\n";

# output result of fish captured from shared resource
print "We now have a total of $captured fish captured\n";
