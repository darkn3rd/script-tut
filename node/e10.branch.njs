#!/usr/bin/node
// prompt and read 1 character
process.stdout.write("Input a character: ");
// attach a listerner to stdin stream async event loop
process.stdin.on('data', processKeypress);   

// functioned to be called when enter key is entered
function processKeypress(keypress) {

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
    
  process.exit();
}