#!/usr/bin/env sh
# Split $PATH on its OS-native delimiter and print each entry on its own
#  line. A given PATH value never mixes both delimiters, so checking for
#  a semicolon first is enough to tell which one actually applies. POSIX
#  sh has no arrays - the split entries become the positional parameters
#  instead (set --), then a plain "for" loop enumerates them. Setting
#  IFS to just the one delimiter character (not the default space/tab/
#  newline) means a directory name containing a space stays intact as a
#  single field.
case "$PATH" in
  *";"*) delim=";" ;;
  *)     delim=":" ;;
esac

oldifs=$IFS
IFS=$delim
set -- $PATH
IFS=$oldifs

for dir in "$@"; do
  echo "$dir"
done
