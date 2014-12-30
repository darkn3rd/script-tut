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

' match() - returns true if pattern found in string
function match(pattern, string)
  set re = new regexp
  re.pattern = pattern
  match = re.test(string)
end function
