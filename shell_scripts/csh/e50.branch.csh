#!/usr/bin/env tcsh
# prompt user and get input
echo -n "Input a character: " # print prompt & acquire input
set keypress=$<               # acquire input

switch ($keypress)
	case [a-z]
		echo "Lowercase letter"
		breaksw
	case [A-Z]
		echo "Uppercase letter"
		breaksw
	case [0-9]
		echo "Digit"
		breaksw
	default
		echo "Punctuation, whitespace, or other"	
endsw
# ^ end block with newline or csh gets confused