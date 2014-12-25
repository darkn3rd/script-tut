#!/usr/bin/env tclsh
# prompt and get input
puts -nonewline "Input a character: "
flush stdout
set keypress [read stdin 1]
# switch on the input (match pattern) and output result
switch -regexp $keypress {
  [a-z] { puts "Lowercase letter" }
  [A-Z] { puts "Uppercase letter" }
  [0-9] { puts "Digit" }
  default { puts "Punctuation, whitespace, or other" }
}
