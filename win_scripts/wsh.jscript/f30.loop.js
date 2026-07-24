// spin loop as condition is always true
//  use break to exit out of loop
do {
  // prompt user
  WScript.stdout.write("Enter your name (quit to exit): ");
  answer = WScript.stdin.readline();         // get input

  // exit loop is user quits
  if (answer == "quit") break

  // output result as not exiting
  WScript.Echo("Hello " + answer + "!");
} while (true)
