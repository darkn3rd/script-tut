// Enumerate a fixed set of well-known environment variables, printing
//  "NAME=value" for each. WSH is Windows-only - USERNAME/USERPROFILE/
//  TEMP/COMPUTERNAME are always set natively, no fallback needed.
//  USER/HOME/TMPDIR/HOSTNAME are POSIX concepts with no Windows
//  equivalent - printed only when actually present (WshEnvironment
//  returns "" for an unset name rather than throwing).
var shell = WScript.CreateObject("WScript.Shell");
var processEnv = shell.Environment("Process");

var names = ["USER", "HOME", "TMPDIR", "HOSTNAME", "USERNAME", "USERPROFILE", "TEMP", "COMPUTERNAME"];
for (var i = 0; i < names.length; i++) {
    var name = names[i];
    var value = processEnv(name);
    if (value !== "") {
        WScript.Echo(name + "=" + value);
    }
}
