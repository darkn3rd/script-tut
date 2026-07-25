#!/usr/bin/env tcsh

# declare variables
set num    = 5
set char   = a
set string = "This is a string"

# output values using string formatting
printf "Number is %d.\n" $num
printf "Character is '%c'.\n" $char
printf 'String is "%s".\n' "$string"
