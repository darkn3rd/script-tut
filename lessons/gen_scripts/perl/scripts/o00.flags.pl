#!/usr/bin/env -S perl -w
use Getopt::Std;

my $usage = <<END;

Usage: $0 [-c|-e|-l|-k|-p|-m|-t] [-h|-?]

  -c  Coffee
  -e  Espresso
  -l  Latte
  -k  Machiato
  -p  Capucino
  -m  Mocha
  -t  Tea
  -h  Display this help message
  -?  Display this help message

END

my %opts;
getopts('celkpmth?', \%opts);

if ($opts{c}) { print "You ordered a Coffee.\n"; exit 0; }
if ($opts{e}) { print "You ordered an Espresso.\n"; exit 0; }
if ($opts{l}) { print "You ordered a Latte.\n"; exit 0; }
if ($opts{k}) { print "You ordered a Machiato.\n"; exit 0; }
if ($opts{p}) { print "You ordered a Capucino.\n"; exit 0; }
if ($opts{m}) { print "You ordered a Mocha.\n"; exit 0; }
if ($opts{t}) { print "You ordered a Tea.\n"; exit 0; }
if ($opts{h} || $opts{'?'}) { print $usage; exit 0; }

print STDERR $usage;
exit 1;
