#!/usr/bin/env tcsh
# Split $PATH on its OS-native delimiter and print each entry on its own
#  line. A given PATH value never mixes both delimiters, so checking for
#  a semicolon first is enough to tell which one actually applies. tcsh
#  has no string-splitting builtin, and its own foreach word-splits a
#  command substitution's output on every whitespace character (not
#  just newlines) - which would wrongly break apart a directory name
#  containing a space (e.g. "C:\Program Files\..."). Piping straight
#  through tr instead sidesteps that entirely: it just swaps the
#  delimiter for a newline and leaves every other character, spaces
#  included, untouched.
if ("$PATH" =~ "*;*") then
  set delim = ";"
else
  set delim = ":"
endif

echo "$PATH" | tr "$delim" '\n'
