#!/usr/bin/env pwsh
# Split the PATH environment variable on its OS-native delimiter and
#  print each entry on its own line. A given PATH value never mixes
#  both delimiters, so checking for a semicolon first is enough to tell
#  which one actually applies.
$path = $env:PATH
$delim = if ($path.Contains(";")) { ";" } else { ":" }
$path.Split($delim) | ForEach-Object { Write-Output $_ }
