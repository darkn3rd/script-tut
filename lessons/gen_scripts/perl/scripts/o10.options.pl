#!/usr/bin/env -S perl -w
# Getopt::Std's %opts hash doesn't preserve the order flags were given
#  in (see o00.flags.pl for that approach) - a plain @ARGV loop is used
#  here instead, since the order they were ordered in matters.
my $usage = <<END;

Usage: $0 [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]

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

my %flags = (
  '-c' => 'coffee',
  '-e' => 'espresso',
  '-l' => 'latte',
  '-k' => 'macchiato',
  '-p' => 'capucino',
  '-m' => 'mocha',
  '-t' => 'tea',
);

my @orders;
for my $arg (@ARGV) {
  if ($arg eq '-h' || $arg eq '-?') {
    print $usage;
    exit 0;
  } elsif (exists $flags{$arg}) {
    push @orders, $flags{$arg};
  }
}

unless (@orders) {
  print STDERR $usage;
  exit 1;
}

print "\n";
print "You ordered: \n";
for my $drink (@orders) {
  print "* $drink\n";
}
