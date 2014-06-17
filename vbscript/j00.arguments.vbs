arg_count   = Wscript.Arguments.Count ' get num of arguments
script_name = WScript.ScriptName      ' get script name

' check for only 2 arguments
If arg_count <> 2 Then
 ' get host environment
 ' Note: Assumes C:\Windows\SysWOW64\cscript.exe or something similar
 ScriptHostName = Split(WScript.FullName, "\")(3)  ' get 4th element after split
 ' print helpful instructions
 WScript.Echo "You need to enter two numbers: " & vbCrLf & vbCrLf & _
              vbTab & ScriptHostName & " //NoLogo " & script_name & " num1 num2"
Else
 ' print sum of the two integer arguments
 WScript.Echo "The sum of " & WScript.Arguments.Item(0) & _
              " and " & WScript.Arguments.Item(1) & _
              " is: " & (Int(WScript.Arguments.Item(0)) + WScript.Arguments.Item(1))
End If