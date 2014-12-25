#!/usr/bin/env perl -w
# create subroutine with one parameter
sub celsius {
  my $fahrenheit = $_[0]; # retreive single parameter

  # convert to new temperature
  $temperature = ($fahrenheit - 32) * 5 / 9;
  # output results with one degree of significance
  printf "The Celsius temperature is %0.1f degrees.\n", $temperature;
}

my $temperature = 73;     # store original temperature
celsius $temperature;     # call function to convert and output results
