#!/bin/bash
# declare variables
declare -i num=10/2        # explicitly set an integer
char=a                     # set a character
string="This is a string"  # set a string

# show the results
printf "Number is $num.\n" $num
printf "Character is \'$char\'.\n" $char
printf "String is \"$string\".\n" $string
