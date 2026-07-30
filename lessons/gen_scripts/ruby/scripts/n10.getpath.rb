#!/usr/bin/env ruby
# Split the PATH environment variable on its OS-native delimiter and
#  print each entry on its own line. A given PATH value never mixes
#  both delimiters, so checking for a semicolon first is enough to tell
#  which one actually applies.
path = ENV["PATH"]
delim = path.include?(";") ? ";" : ":"
path.split(delim).each { |dir| puts dir }
