
# create function (subroutine)
Function Capitalize ($string) { 
    $string.ToUpper()           # return fully uppdercase $string
}

# call the function (subroutine)
$result = Capitalize "ibm"

# output results
"The resulting string is: $result."