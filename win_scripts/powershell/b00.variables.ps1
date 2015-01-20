#!/usr/bin/env pash
# declare variables
Set-Variable -name num    -value 5
Set-Variable -name char   -value 'a'
Set-Variable -name string -value "This is a string"

# output variables using string concatenation
"Number is " + $num + "."
"Character is '" + $char + "'."
"String is `"" + $string + "`"."
