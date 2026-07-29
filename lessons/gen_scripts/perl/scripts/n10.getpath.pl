#!/usr/bin/env perl -w
# Split the PATH environment variable on its OS-native delimiter and
#  print each entry on its own line. A given PATH value never mixes
#  both delimiters, so checking for a semicolon first is enough to tell
#  which one actually applies.
my $path = $ENV{PATH};
my $delim = (index($path, ";") >= 0) ? ";" : ":";
print "$_\n" for split(/\Q$delim\E/, $path);
