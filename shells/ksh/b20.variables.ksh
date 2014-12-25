#!/usr/bin/env ksh
# declare variables
typeset -i num=10/2        # set an integer
char=a                     # set a character
string="This is a string"  # set a string

# output results using formatting
printf "Number is %d." $num
printf "Character is \'%c\'." $char
printf "String is \"%s\"." $string
