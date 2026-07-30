#!/usr/bin/env pwsh
# Named [switch] parameters (see o00.flags.ps1) don't preserve the
#  order flags were given in - they're just booleans, with no memory of
#  position - so a plain $args loop is used here instead, since the
#  order they were ordered in matters.
$scriptName = $MyInvocation.MyCommand.Name

$usage = @"

Usage: $scriptName [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]

  -c  Coffee
  -e  Espresso
  -l  Latte
  -k  Machiato
  -p  Capucino
  -m  Mocha
  -t  Tea
  -h  Display this help message
  -?  Display this help message


"@

$flags = @{
    "-c" = "coffee"
    "-e" = "espresso"
    "-l" = "latte"
    "-k" = "macchiato"
    "-p" = "capucino"
    "-m" = "mocha"
    "-t" = "tea"
}

$orders = @()
foreach ($arg in $args) {
    if ($arg -eq "-h" -or $arg -eq "-?") {
        # Console.Write, not Write-Output, here - Write-Output goes
        #  through PowerShell's own formatting pipeline and adds its
        #  own trailing CRLF on top of whatever's already in the
        #  string, while Console.Write is a raw passthrough.
        [Console]::Out.Write($usage)
        exit 0
    } elseif ($flags.ContainsKey($arg)) {
        $orders += $flags[$arg]
    }
}

if ($orders.Count -eq 0) {
    [Console]::Error.Write($usage)
    exit 1
}

Write-Output ""
Write-Output "You ordered: "
foreach ($drink in $orders) {
    Write-Output "* $drink"
}
