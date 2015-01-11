#!/usr/bin/env perl -w
# acquire num of args and script name
$arg_count   = $#ARGV + 1; # get num of arguments
$script_name = $0;         # get script name
$EX_USAGE    = 64;         # status for command line usage error
$EX_OK       = 0;          # status for successful termination

# check for correct number of arguments
if ($arg_count < 1) {
	usage_message();         # output usage message
} else {
	addNums(@ARGV)           # process arguments
}

# output a usage message
sub usage_message {
  # output usage statement to standard error
  print STDERR "\nYou need to enter one or more numbers:\n\n";
  print STDERR "   Usage: $script_name [num1] [num2] [num3]...\n\n";
  exit $EX_USAGE;          # return error code
}

# create subroutine with variable parameters
sub addNums {
   my @numbers = @_;       # retreive variable parameters
   my $sum = 0;            # initalize to 0

   # add all the $num in @numbers list
   foreach $num (@numbers) { $sum += $num }

   # output results
   print "The summation is: $sum\n";
   exit $EX_OK;            # return a success
}
