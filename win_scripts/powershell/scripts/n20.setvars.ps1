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
[Console]::Out.Write("MY_ORDERS set, Hit Return to continue`n")
[Console]::In.ReadLine() | Out-Null

Remove-Item -Path dump_env.out -Force
