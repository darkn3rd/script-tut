' prompt and read response
wscript.stdout.write "Would you like a toast? [Yes/No]: "
response = wscript.stdin.readline

' test response to a string using if/else construction
if response = "Yes" then
  wscript.echo "That's great!"
else
  wscript.echo "How about a muffin?"
end if
