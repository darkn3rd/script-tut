' create function
Function Capitalize(string)
  Capitalize = Ucase(string) 
End Function

' call the function
result = Capitalize("ibm")

WScript.Echo "The resulting string is: " & result & "."

