#!/usr/bin/env pwsh
# $Host.UI.RawUI.ReadKey() needs a real interactive console and fails/hangs
#  on a redirected/piped stdin. [Console]::In.Read() reads a single
#  character's code from the stream and works fine non-interactively.
Write-Host -NoNewline "Input a character: "
$character = [char][Console]::In.Read()
"You entered: >>|$character|<<."
