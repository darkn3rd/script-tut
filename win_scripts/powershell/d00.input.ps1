#!/usr/bin/env pwsh
# Read-Host echoes back whatever it reads from a redirected/piped stdin
#  (not just a real interactive console), which corrupts output when this
#  runs non-interactively. [Console]::In.ReadLine() doesn't echo.
Write-Host -NoNewline "Enter your name: "
$name = [Console]::In.ReadLine()
"Hello $name!"
