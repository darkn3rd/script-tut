#!/usr/bin/env pash
# Read-Host echoes back piped/redirected input - see d00.input.ps1
Write-Host -NoNewline "Input a character: "
$keypress = [Console]::In.ReadLine()          # prompt user and get input
$keypress = $keypress.substring(0,1)        # substring for only 1st char

# evaluate keypress matches pattern
if  ($keypress -cmatch "[a-z]") {
  "Lowercase letter"
} elseif ($keypress -cmatch "[A-Z]") {
  "Uppercase letter"
} elseif ($keypress -cmatch "[0-9]") {
  "Digit"
} else {
  "Punctuation, whitespace, or other"
}
