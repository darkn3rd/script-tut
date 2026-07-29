#!/usr/bin/env ksh
# Split $PATH on its OS-native delimiter and print each entry on its own
#  line. A given PATH value never mixes both delimiters, so checking for
#  a semicolon first is enough to tell which one actually applies.
#  Setting IFS to just the one delimiter character (not the default
#  space/tab/newline) before "set --" means a directory name containing
#  a space stays intact as a single field.
case "$PATH" in
  *";"*) delim=";" ;;
  *)     delim=":" ;;
esac

oldifs=$IFS
IFS=$delim
set -- $PATH
IFS=$oldifs

for dir in "$@"; do
  print "$dir"
done
