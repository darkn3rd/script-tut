' prompt and read response
wscript.stdout.write "Would you like a toast? [Yes/No]: "
response = wscript.stdin.readline

' test response using array-index selection (VBScript has no ternary
'  operator or usable IIf() in the base engine - IIf() always evaluates
'  both branches and errors here with a type mismatch). True is -1 in
'  VBScript, so negate it to get the 0/1 array index.
wscript.echo Array("How about a muffin?", "That's great!")(-CInt(response = "Yes"))
