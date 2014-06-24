var answer;  // Must declare variable before evaluation
// conditional loop with while construct
while (answer != "quit") {
  // prompt user
  WScript.stdout.write("Enter your name (quit to Exit): ");
  answer = WScript.stdin.readline();         // get input
  if (answer != "quit") 
      WScript.Echo("Hello " + answer + "!"); // prompt user if not exiting
}
