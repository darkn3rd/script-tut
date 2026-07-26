// Split the PATH environment variable on its OS-native delimiter and
//  print each entry on its own line. A given PATH value never mixes
//  both delimiters, so checking for a semicolon first is enough to
//  tell which one actually applies.
var shell = WScript.CreateObject("WScript.Shell");
var path = shell.Environment("Process")("PATH");
var delim = (path.indexOf(";") >= 0) ? ";" : ":";
var dirs = path.split(delim);
for (var i = 0; i < dirs.length; i++) {
    WScript.Echo(dirs[i]);
}
