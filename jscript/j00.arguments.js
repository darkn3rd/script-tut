// check for only two arguments
if (WScript.Arguments.Count() != 2) {

 // get host environment

 // Note: Assumes C:\Windows\SysWOW64\cscript.exe or something similar
 ScriptHostName = WScript.FullName.split("\\")[3]; // get 4th element after split

 // print helpful instructions
 WScript.Echo("You need to enter two numbers: \n\n\t" +
              ScriptHostName + " //NoLogo " + WScript.ScriptName + " num1 num2");

} else {

 // print sum of the two integer arguments
 WScript.Echo("The sum of " + WScript.Arguments.Item(0) + 
              " and " + WScript.Arguments.Item(1) + " is: " + 
              (parseInt(WScript.Arguments.Item(0)) + parseInt(WScript.Arguments.Item(1)))
             );

}

