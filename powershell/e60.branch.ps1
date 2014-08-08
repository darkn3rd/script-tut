$keypress = Read-Host "Input a character: " # prompt user and get input
$keypress = $keypress.substring(0,1)        # substring for only 1st char

# evaluate keypress matches pattern
if  ($keypress -cmatch "[a-z]") {
  "Lowercase letter"
} elseif ($keypress -cmatch "[A-Z]") {
  "Uppercase letter"
} elseif ($keypress -cmatch "[0-9]") {
  "Digit"
} else {
  "Punctuation, whitepace, or other"
}
