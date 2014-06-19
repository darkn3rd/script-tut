#!/usr/bin/node

// COM objects used in script
var fso   = new ActiveXObject("Scripting.FileSystemObject")
var shell = new ActiveXObject("WScript.shell")
var dirlist = exec("cmd /c dir /b");                // get Array of directory items

// iterate each item returned from subshell 
for (var index in dirlist) {
   item = dirlist[index];                           // extract value from hash
   // test item is a directory
   if (fso.folderexists(item)) { 
       console.log(item + " is a directory");
   } else {
       console.log(item + " is not a directory");
   } 
}

// exec() - given command returns array of result
function exec (cmd) {
  var files  = new Array();                // create local array
  var size   = 0;                          // create starting size
  var stdout = shell.exec(cmd).stdout      // capture stdout from exec
  
  // iterate through lines & save each item into array
  while (!stdout.AtEndofStream) { files.push(stdout.ReadLine()); }

  return files;                            // return Array (which is really JScript hash) 
}
