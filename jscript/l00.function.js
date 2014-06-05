' create function
Function AddNums(args)
  For Each num In args  ' iterate through each argument
    sum = sum + num     ' sum up all the numbers
  Next

  AddNums = sum         ' set return to sum
End Function

' call the function
result = AddNums(Array(5,2,4,3,6))

WScript.Echo "The result of summation is: " & result & "."

