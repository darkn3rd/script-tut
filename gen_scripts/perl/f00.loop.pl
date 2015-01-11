#!/usr/bin/env perl -w

# collection loop on list returned by subshell
foreach $item (split /\s+/, `ls dirtest`) {
  if (-d "dirtest/$item") {
    print "$item is a directory\n"
  } else {
    print "$item is not a directory\n"
  }
}
