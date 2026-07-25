#!/usr/bin/env perl -w
# testbox: title="opendir/readdir with foreach collection"

# collection loop on list returned by Perl's own directory-reading
#  functions, without a subshell - see f00.loop.pl for the subshell
#  (`ls`) version of this same lesson
opendir(my $dh, "dirtest") or die "Cannot open dirtest: $!";
my @items = sort grep { $_ ne "." && $_ ne ".." } readdir($dh);
closedir($dh);

foreach $item (@items) {
  if (-d "dirtest/$item") {
    print "$item is a directory\n"
  } else {
    print "$item is not a directory\n"
  }
}
