#!/usr/bin/env bash
# declare variables
declare -i num=10/2        # explicitly set an integer
char=a                     # set a character
string="This is a string"  # set a string

# show the results using formatting
printf "Number is %d.\n" $num
printf "Character is \'%c\'.\n" $char
printf "String is \"%s\".\n" $string
