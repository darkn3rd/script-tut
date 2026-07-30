#!/usr/bin/env -S perl -w
# Getopt::Long can't easily be told "collect flags in the order they
#  were given, allowing repeats" - it fills one fixed destination per
#  flag - so this is parsed by hand instead, matching the technique
#  used across every other language's o20 lesson.
my $usage = <<END;

Usage: $0 [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]

  --coffee,    -c N  Coffee
  --espresso,  -e N  Espresso
  --latte,     -l N  Latte
  --macchiato, -k N  Machiato
  --capucino,  -p N  Capucino
  --mocha,     -m N  Mocha
  --tea,       -t N  Tea
  --help,      -h    Display this help message
  -?                 Display this help message

END

my %flags = (
  '--coffee' => 'coffee',   '-c' => 'coffee',
  '--espresso' => 'espresso', '-e' => 'espresso',
  '--latte' => 'latte',     '-l' => 'latte',
  '--macchiato' => 'macchiato', '-k' => 'macchiato',
  '--capucino' => 'capucino', '-p' => 'capucino',
  '--mocha' => 'mocha',     '-m' => 'mocha',
  '--tea' => 'tea',         '-t' => 'tea',
);

my @orders;
my $i = 0;
while ($i < scalar(@ARGV)) {
  my $arg = $ARGV[$i];
  if ($arg eq '--help' || $arg eq '-h' || $arg eq '-?') {
    print $usage;
    exit 0;
  } elsif (exists $flags{$arg}) {
    my $name = $flags{$arg};
    my $n = $ARGV[$i + 1];
    push @orders, "$n " . ($n == 1 ? $name : "${name}s");
    $i += 2;
  } else {
    print STDERR $usage;
    exit 1;
  }
}

unless (@orders) {
  print STDERR $usage;
  exit 1;
}

print "\n";
print "You ordered: \n";
for my $order (@orders) {
  print "* $order\n";
}
