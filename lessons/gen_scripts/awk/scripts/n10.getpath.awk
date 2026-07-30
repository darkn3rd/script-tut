#!/usr/bin/env -S gawk -f
# Split the PATH environment variable on its OS-native delimiter and
#  print each entry on its own line. A given PATH value never mixes
#  both delimiters, so checking for a semicolon first is enough to tell
#  which one actually applies.
BEGIN {
  path = ENVIRON["PATH"]
  delim = (index(path, ";") > 0) ? ";" : ":"
  n = split(path, dirs, delim)
  for (i = 1; i <= n; i++) print dirs[i]
}
