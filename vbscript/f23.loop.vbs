' conditional loop w. positive check at beginning
While (answer <> "quit")
  ' prompt user for input
  WScript.StdOut.Write "Enter your name (quit to Exit): "
  ' get answer from user
  answer = WScript.StdIn.ReadLine
  If answer <> "quit" Then
      ' output results if not exiting
      WScript.Echo "Hello " & answer & "!"
  End If
Wend