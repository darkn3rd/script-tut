#!/usr/bin/perl -w
# acquire num of args and script name
$arg_count   = $#ARGV + 1;    # get num of arguments
$script_name = $0;            # get script name

if ($arg_count != 2) {
  # print helpful instructions
  print "\nYou need to enter two numbers: \n\n";
  print "   Usage: $script_name [num1] [num2]\n\n";
} else {
  $sum = $ARGV[0] + $ARGV[1]; # get sum of both arguments
  # print results of both arguments and summation
  printf  "The sum of %d and %d is: %d.\n", $ARGV[0], $ARGV[1], $sum;
}