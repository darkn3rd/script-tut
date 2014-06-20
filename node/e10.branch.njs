#!/usr/bin/node
// prompt and read 1 character
WScript.stdout.write("Input a character: ");
keypress = WScript.stdin.read(1);

// find match and print result
switch (true) {
  case RegExp("[a-z]").test(keypress):
    console.log("Lowercase letter");
    break;
  case RegExp("[A-Z]").test(keypress):
    console.log("Uppercase letter");
    break;
  case RegExp("[0-9]").test(keypress):
    console.log("Digit");
    break;
  default:
    console.log("Punctuation, whitespace, or other");
}
