#!/usr/bin/env -S perl -w
my %drinks = (
  Capucino => 0,
  Coffee   => 0,
  Espresso => 0,
  Latte    => 0,
  Machiato => 0,
  Mocha    => 0,
  Tea      => 0,
);

if (@ARGV == 0) {
  for my $key (keys %drinks) {
    $drinks{$key} = int(rand(3));
  }
} else {
  for my $pair (@ARGV) {
    my ($key, $qty) = split(/:/, $pair, 2);
    $drinks{$key} = $qty;
  }
}

my $order = join(",", map { "$_:$drinks{$_}" } grep { $drinks{$_} != 0 } sort keys %drinks);

$ENV{MY_ORDERS} = $order;

# Dump the whole environment (plain "KEY=value" lines) to a well-known
#  file for an external observer to inspect while this script is
#  paused below - deleted again once that observer is done and this
#  script is about to exit.
open(my $fh, ">", "dump_env.out") or die $!;
for my $key (keys %ENV) {
  print $fh "$key=$ENV{$key}\n";
}
close($fh);

# Explicit flush - stdout is block-buffered (not line-buffered) once
#  it's a pipe rather than a real terminal, so without this the prompt
#  below might never actually reach the test harness waiting to read it.
$| = 1;
print "MY_ORDERS set, Hit Return to continue\n";
<STDIN>;

unlink("dump_env.out");
