' COM objects used in script
set fso   = createobject("Scripting.FileSystemObject")
set shell = createobject("wscript.shell")

' iterate each item returned from subshell 
for each item in exec("cmd /c dir /b")
   ' test item is a directory
   if fso.folderexists(item) then
       wscript.echo item & " is a directory"    
   else
       wscript.echo item & " is not a directory"
   end if
next

' **************************************
' exec (cmd) - given command returns array of lines from output
'   Helper function to enable iteration through lines of output
'    from running a command.
' **************************************
function exec (cmd)
  dim files()                              ' create local array
  dim size : size = 0                      ' create starting size
  set stdout      = shell.exec(cmd).stdout ' capture stdout from exec
  
  ' iterate through lines & save into array
  while not stdout.atendofstream
    redim preserve files(size)             ' resize the array
    files(size) = stdout.readline          ' append to array
    size = size + 1                        ' increase size counter
  wend

  exec = files                             ' return array
end function
