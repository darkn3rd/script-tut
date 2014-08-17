#!/usr/bin/env pash
# output message to standard error
#  Note: Test by redirecting stdout to nowhere, e.g.
#    C:\> powershell.exe -NoLogo -NoProfile ^
#         -ExecutionPolicy Bypass  -File script.ps1 > NULL
[Console]::Error.WriteLine("This is a test of the emergency script system." + `
                           " This is only a test.")