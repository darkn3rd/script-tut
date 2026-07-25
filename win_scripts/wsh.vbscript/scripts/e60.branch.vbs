' prompt and read one character
wscript.stdout.write "Input a character: "
keypress = wscript.stdin.read(1)

' find match and print result
if match("[a-z]", keypress) then
    wscript.echo "Lowercase letter"
elseif match("[A-Z]", keypress) then
    wscript.echo "Uppercase letter"
elseif (match("[0-9]", keypress)) then
    wscript.echo "Digit"
else
    wscript.echo "Punctuation, whitespace, or other"
end if

' **************************************
' match (pattern, string) - returns true if pattern found in string
'   Helper function to enable select case to match a pattern
' **************************************
function match(pattern, string)
  set re = new regexp
  re.pattern = pattern
  match = re.test(string)
end function
