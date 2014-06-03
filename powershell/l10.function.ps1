
# create function (subroutine)
Function Capitalize ($string) { $string.ToUpper() }

# call the function (subroutine)
$result = Capitalize "ibm"

# output results
"The resulting string is: $result."