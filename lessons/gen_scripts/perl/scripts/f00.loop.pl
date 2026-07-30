#!/usr/bin/env -S perl -w
# testbox: requires=posix
# testbox: title="subshell (ls) with foreach collection"

# collection loop on list returned by subshell
foreach $item (split /\s+/, `ls dirtest`) {
  if (-d "dirtest/$item") {
    print "$item is a directory\n"
  } else {
    print "$item is not a directory\n"
  }
}
