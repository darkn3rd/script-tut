#!/usr/bin/env pash
# create function (subroutine)
Function Capitalize ($string) {
    $string.ToUpper()               # return fully uppdercase $string
}

"The current string is: `"ibm`"."
$result = Capitalize "ibm"          # call the function (subroutine)
"The capitalized string is: `"$result`"." # output results
