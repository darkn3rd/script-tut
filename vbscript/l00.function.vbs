' create function
Function AddNums(args)
  For Each num In args
    sum = sum + num
  Next

  AddNums = sum  
End Function

' call the function
result = AddNums(Array(5,2,4,3,6))

WScript.Echo "The result of summation is: " & result & "."

