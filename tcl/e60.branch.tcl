#!/usr/bin/env tclsh
# prompt and get input
puts -nonewline "Input a character: "
flush stdout
set keypress [read stdin 1]
# evaluate match to pattern and output result
if {[regexp {[a-z]} $keypress]} {
    puts "Lowercase letter"
} elseif {[regexp {[A-Z]} $keypress]} {
    puts "Uppercase letter"
} elseif {[regexp {[0-9]} $keypress]} {
    puts "Digit"
} else {
    puts "Punctuation, whitespace, or other"
}
