' Enumerate a fixed set of well-known environment variables, printing
' "NAME=value" for each. WSH is Windows-only - USERNAME/USERPROFILE/
' TEMP/COMPUTERNAME are always set natively, no fallback needed.
' USER/HOME/TMPDIR/HOSTNAME are POSIX concepts with no Windows
' equivalent - printed only when actually present (WshEnvironment
' returns "" for an unset name rather than raising an error).
set shell = wscript.createobject("WScript.Shell")
set processEnv = shell.Environment("Process")

dim names(7)
names(0) = "USER"
names(1) = "HOME"
names(2) = "TMPDIR"
names(3) = "HOSTNAME"
names(4) = "USERNAME"
names(5) = "USERPROFILE"
names(6) = "TEMP"
names(7) = "COMPUTERNAME"

for i = 0 to 7
  value = processEnv(names(i))
  if value <> "" then
    wscript.echo names(i) & "=" & value
  end if
next
