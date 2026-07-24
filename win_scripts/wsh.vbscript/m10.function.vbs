' create function
Function Capitalize(string)
  Capitalize = Ucase(string)  ' return fully upppercase string
End Function

' call the function
original = "ibm"
result = Capitalize(original)

' output results
WScript.Echo "The current string is: " & Chr(34) & original & Chr(34) & "."
WScript.Echo "The capitalized string is: " & Chr(34) & result & Chr(34) & "."

