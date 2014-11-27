#!/bin/tcsh
# prompt user and get input
echo -n "Input a character: " # print prompt & acquire input
set keypress=$<               # acquire input

# test input and output result
if ( `expr $keypress : "[a-z]"`) then
	echo "Lowercase letter"
else if ( `expr $keypress : "[A-Z]"` ) then
	echo "Uppdercase letter"
else if ( `expr $keypress : "[0-9]"` ) then
	echo "Digit"
else
	echo "Punctuation, whitespace, or other"	
endif
# ^ newline required or failure