# create function (subroutine)
Function Capitalize ($string) { 
    $string.ToUpper()               # return fully uppdercase $string
}

$result = Capitalize "ibm"          # call the function (subroutine)
"The resulting string is: $result." # output results