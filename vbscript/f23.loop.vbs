while (answer <> "quit")
  wscript.stdout.write "Enter your name (quit to Exit): "
  answer = wscript.stdin.readline
  if answer <> "quit" then
      wscript.echo "Hello " & answer & "!"
  end if
wend