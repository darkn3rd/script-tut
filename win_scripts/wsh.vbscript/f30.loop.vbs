' spin loop at condition is always true
Do While True 
  ' prompt user for input
  WScript.StdOut.Write "Enter your name (quit to Exit): "
  ' get answer from user
  answer = WScript.StdIn.ReadLine 
  If answer = "quit" Then
      ' exit loop when user wants to quit
      Exit Do                       
  End If
  
  ' output results if not exiting
  WScript.Echo "Hello " & answer & "!"
Loop
