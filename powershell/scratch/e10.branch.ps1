
$keypress = Read-Host "Input a character: " # prompt user and get input
$keypress = $keypress.substring(0,1)        # substring for only 1st char

# switch w/ regexp construction
switch -regex -casesensitive ($keypress) {
 "[:lower:]" { "Lowercase letter"}
 "[:upper:]" { "Uppercase letter"}
 "[:digit:]" { "Digit" }
 default { "Punctuation, whitespace, or other" }
}
