' utility variables needed for VBScript environment
Set noInput = new RegExp    ' new RegExp object
noInput.pattern = "^$"      ' initialize empty string regexp pattern

' spin loop at condition is always true
Do While True 
  ' prompt user for input
  WScript.StdOut.Write "Enter your name (quit to Exit): "
  ' get answer from user
  answer = WScript.StdIn.ReadLine 
  
  ' do work if we got an answer
  '   Note: VBScript has no mechanism to skip loops
  '    so we insulate processing answer in if block
  if not noInput.test(answer) Then	  
    If answer = "quit" Then
      Exit Do                   ' exit loop when user wants to quit           
    End If
  
    ' output results if not exiting
    WScript.Echo "Hello " & answer & "!"
  End If
Loop
