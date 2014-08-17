#!/usr/bin/env pash
$keypress = Read-Host "Input a character: " # prompt user and get input
$keypress = $keypress.substring(0,1)        # substring for only 1st char

# switch w/ regexp construction
switch -regex -casesensitive ($keypress) {
 "[a-z]" { "Lowercase letter"}
 "[A-Z]" { "Uppercase letter"}
 "[0-9]" { "Digit" }
 default { "Punctuation, whitespace, or other" }
}