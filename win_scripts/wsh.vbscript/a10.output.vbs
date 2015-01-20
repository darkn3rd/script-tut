' output message to standard error
'  Note: Test by redirecting stdout to nowhere, e.g.
'   C:\> cscript script.vbs > NUL
WScript.StdErr.Write "This is a test of the emergency script system." & _
                     "  This is only a test.\n"
