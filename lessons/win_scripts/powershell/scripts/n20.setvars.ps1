#!/usr/bin/env pwsh
$drinks = [ordered]@{
    Capucino = 0
    Coffee   = 0
    Espresso = 0
    Latte    = 0
    Machiato = 0
    Mocha    = 0
    Tea      = 0
}

if ($args.Count -eq 0) {
    foreach ($key in @($drinks.Keys)) {
        $drinks[$key] = Get-Random -Minimum 0 -Maximum 3
    }
} else {
    foreach ($pair in $args) {
        $parts = $pair -split ":", 2
        $drinks[$parts[0]] = [int]$parts[1]
    }
}

$parts = foreach ($key in ($drinks.Keys | Sort-Object)) {
    if ($drinks[$key] -ne 0) { "${key}:$($drinks[$key])" }
}
$order = $parts -join ","

[Environment]::SetEnvironmentVariable("MY_ORDERS", $order, "Process")

# Dump the whole environment (plain "KEY=value" lines) to a well-known
#  file for an external observer to inspect while this script is
#  paused below - deleted again once that observer is done and this
#  script is about to exit.
Get-ChildItem Env: | ForEach-Object { "$($_.Name)=$($_.Value)" } | Set-Content -Path dump_env.out

# Console.Write, not Write-Output, here - Write-Output goes through
#  PowerShell's own formatting pipeline and adds its own trailing CRLF,
#  which isn't itself a problem here, but Console.Write keeps this
#  consistent with the other lessons that need exact control over it.
#  Flush explicitly - confirmed directly this matters when stdout is a
#  pipe rather than a real console: testbox/Script.rb's own
#  env_shell_out reads this process through Open3.popen3, and without
#  an explicit Flush() here, Windows PowerShell 5.1's buffered
#  Console.Out can hold this line internally rather than writing it
#  through to the pipe - the harness then blocks forever in
#  stdout.readline waiting for a line that's sitting in a buffer it
#  can't see, while this script sits blocked in ReadLine() waiting for
#  the harness's own reply - a deadlock neither side can break.
[Console]::Out.Write("MY_ORDERS set, Hit Return to continue`n")
[Console]::Out.Flush()
[Console]::In.ReadLine() | Out-Null

Remove-Item -Path dump_env.out -Force
