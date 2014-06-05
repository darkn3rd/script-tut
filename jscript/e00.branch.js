WScript.stdout.write("Input a number: ");
number = WScript.stdin.readline();

if (number > 0) {                            // automatic coercion to int
   WScript.Echo("Number is greater than 0");
} else if (number < 0) { 
   WScript.Echo("Number is less than 0");
} else {
   WScript.Echo("Number is 0");
}
