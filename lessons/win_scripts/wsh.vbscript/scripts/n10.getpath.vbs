' Split the PATH environment variable on its OS-native delimiter and
' print each entry on its own line. A given PATH value never mixes
' both delimiters, so checking for a semicolon first is enough to tell
' which one actually applies.
set shell = wscript.createobject("WScript.Shell")
path = shell.Environment("Process")("PATH")

if instr(path, ";") > 0 then
  delim = ";"
else
  delim = ":"
end if

dirs = split(path, delim)
for i = 0 to ubound(dirs)
  wscript.echo dirs(i)
next
