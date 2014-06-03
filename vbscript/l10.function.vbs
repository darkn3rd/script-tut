' create function
Function Capitalize(string)
  Capitalize = Ucase(string)  ' return fully upppercase string
End Function

' call the function
result = Capitalize("ibm")

' output results
WScript.Echo "The resulting string is: " & result & "."

