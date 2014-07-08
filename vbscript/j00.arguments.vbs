arg_count   = Wscript.Arguments.Count ' get num of arguments
script_name = WScript.ScriptName      ' get script name

' check for only 2 arguments
If arg_count <> 2 Then
 ' print helpful instructions
 WScript.StdErr.Write vbCrLf & "You need to enter two numbers: " & vbCrLf
 WScript.StdErr.Write "   Usage: " & script_name & " [num1] [num2]"
Else
 ' get sum of both arguments, force cast to integer
 sum = Int(WScript.Arguments.Item(0)) + WScript.Arguments.Item(1)
 ' print results of both arguments (string) and summation (integer)
 WScript.Echo "The sum of " & WScript.Arguments.Item(0) & _
              " and " & WScript.Arguments.Item(1) & _
              " is: " & sum & "."
End If