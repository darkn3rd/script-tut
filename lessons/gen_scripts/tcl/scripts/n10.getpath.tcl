#!/usr/bin/env tclsh
# Split the PATH environment variable on its OS-native delimiter and
#  print each entry on its own line. A given PATH value never mixes
#  both delimiters, so checking for a semicolon first is enough to tell
#  which one actually applies.
set path $env(PATH)
if {[string first ";" $path] >= 0} {
  set delim ";"
} else {
  set delim ":"
}

foreach dir [split $path $delim] {
  puts $dir
}
