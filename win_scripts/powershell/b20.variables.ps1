#!/usr/bin/env pash
# declare variables
$num    = 5
$char   = 'a'
$string = "This is a string"

# output variables using interpolation using formatted strings
"Number is {0}." -f $num
"Character is '{0}'." -f $char
"String is `"{0}`"." -f $string