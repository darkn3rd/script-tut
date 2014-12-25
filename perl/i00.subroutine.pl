#!/usr/bin/env perl -w
use POSIX qw(strftime);  # library to get us strftime

# create subroutine
sub show_date {
  my $date = strftime("%B %d, %Y", gmtime(time));
  print "Today is $date.\n";
}

# call subroutine
show_date
