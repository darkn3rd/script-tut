var answer;  // Must declare variable before evaluation

while (answer != "quit") {
  WScript.stdout.write("Enter your name (quit to Exit): ");
  answer = WScript.stdin.readline();
  if (answer != "quit") {
      WScript.Echo("Hello " + answer + "!");
  } 
}
