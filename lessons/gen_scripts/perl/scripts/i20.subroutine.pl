#!/usr/bin/env -S perl -w
# declare package globals (no "my", so visible to every sub in this file)
our $pond     = 500; # pond contains some available fish
our $captured = 0;   # captured represents fish captured

# create subroutine
sub fish {
  my $pond   = 500; # "my" makes this a new lexical that shadows the global $pond, local to this sub only
  $pond     -= 150; # subtract from the local pond; the global $pond is untouched
  $captured += 150; # add to the fish captured (still the global)
}

# output initial amount of fish in shared resource
print "We have $pond in this pond.\n";

fish();                                                            # get some fish
print "Fishing from a local pond... We now have $pond in the main pond.\n";

fish();                                                            # get some fish
print "Fishing from a local pond... We now have $pond in the main pond.\n";

fish();                                                            # get some fish
print "Fishing from a local pond... We now have $pond in the main pond.\n";

# output result of fish captured from local resource
print "We now have a total of $captured fish captured\n";
