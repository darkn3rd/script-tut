' COM object used for testing files
Set fso   = CreateObject("Scripting.FileSystemObject")


' collection loop fetches each item from exec
For Each item In exec("cmd /c dir /b")
   ' test item is a directory
   If fso.FolderExists(item) Then
       WScript.Echo item & " is a directory"    
   Else
       WScript.Echo item & " is not a directory"
   End If
Next

' **************************************
' exec (cmd) - given command returns array of lines from output
'   Helper function to enable iteration through lines of output
'    from running a command.
' **************************************
Function exec (cmd)
  ' utility variable
  Dim files()                              ' create local refernce to empty array
  Dim size : size = 0                      ' create starting size
  ' com objects used for subshell interaction
  Set shell       = CreateObject("WScript.Shell")
  Set stdout      = shell.Exec(cmd).StdOut ' get stdout ojbect from exec method
  
  ' iterate through lines & save into array
  While Not stdout.AtEndOfStream
    ReDim Preserve files(size)             ' resize the array
    files(size) = stdout.ReadLine          ' append to array
    size = size + 1                        ' increase size counter
  Wend

  exec = files                             ' return array
End Function
