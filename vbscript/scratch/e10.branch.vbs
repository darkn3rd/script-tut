' prompt and read 1 character
wscript.stdout.write "Input a character: "
keypress = wscript.stdin.read(1)

' find match and print result
select case true
  case match("[a-z]", keypress)
    wscript.echo "Lowercase letter"
  case match("[A-Z]", keypress)
    wscript.echo "Uppercase letter"
  case match("[0-9]", keypress)
    wscript.echo "Digit"
  case else
    wscript.echo "Punctuation, whitespace, or other"
end select

' match() - returns true if pattern found in string
function match(pattern, string)
  set re = new regexp
  re.pattern = pattern
  match = re.test(string)
end function
