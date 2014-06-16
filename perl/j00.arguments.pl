#!/usr/bin/perl -w
# acquire num of args and script name
$arg_count   = $#ARGV + 1; # get num of arguments
$script_name = $0;         # get script name

if ($arg_count != 2) {
  print "You need to enter two numbers: \"$script_name\" num1 num2.\n";
} else {
  printf  "The sum of %d and %d is: %d.\n", $ARGV[0], $ARGV[1], $ARGV[0] + $ARGV[1];
}