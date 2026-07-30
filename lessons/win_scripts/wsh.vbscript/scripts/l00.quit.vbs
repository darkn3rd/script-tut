' illustrative variables
arg_count   = Wscript.Arguments.Count ' get num of arguments
script_name = WScript.ScriptName      ' get script name
EX_USAGE    = 64                      ' status for command line usage error
EX_OK       = 0                       ' status for successful termination

' check to make sure one argument exists
If arg_count < 1 Then
   usage_message
Else
   addNums WScript.Arguments
End If

Sub usage_message()
   ' print helpful instructions
   WScript.StdErr.Write vbCrLf & "You need to enter one or more numbers:" & vbCrLf & _
                        vbCrLf & "   Usage: " & script_name & _
                        " [num1] [num2] [num3]..." & vbCrLf & vbCrLf
   WScript.Quit EX_USAGE
End Sub

' create function
Sub addNums(args)
    For Each num In args     ' iterate through each argument
        sum = sum + Int(num) ' sum up all the numbers
    Next
    
    WScript.Echo "The summation is: " & sum & "."
    WScript.Quit EX_OK       ' return a success
End Sub
