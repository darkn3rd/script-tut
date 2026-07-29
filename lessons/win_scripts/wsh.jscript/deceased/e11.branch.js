// prompt and read 1 character
WScript.stdout.write("Input a character: ");
keypress = WScript.stdin.read(1);

// find match and print result
switch (keypress) {
  case /[a-z]/:
    WScript.Echo("Lowercase letter");
    break;
  case /[A-Z]/:
    WScript.Echo("Uppercase letter");
    break;
  case /[0-9]/:
    WScript.Echo("Digit");
    break;
  default:
    WScript.Echo("Punctuation, whitespace, or other");
}

// match() - returns true if pattern found in string
function match(pattern, string) 
{
  var re = new RegExp(pattern);
  return re.test(string);
}
