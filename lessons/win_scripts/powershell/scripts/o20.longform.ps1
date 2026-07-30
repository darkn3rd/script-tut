#!/usr/bin/env pwsh
# Named [switch] parameters (see o00.flags.ps1) can't take a following
#  value or preserve the order flags were given in - so this is parsed
#  entirely by hand instead, matching the technique used across every
#  other language's o20 lesson.
$scriptName = $MyInvocation.MyCommand.Name

$usage = @"

Usage: $scriptName [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]

  --coffee,    -c N  Coffee
  --espresso,  -e N  Espresso
  --latte,     -l N  Latte
  --macchiato, -k N  Machiato
  --capucino,  -p N  Capucino
  --mocha,     -m N  Mocha
  --tea,       -t N  Tea
  --help,      -h    Display this help message
  -?                 Display this help message


"@

$flags = @{
    "--coffee" = "coffee";   "-c" = "coffee"
    "--espresso" = "espresso"; "-e" = "espresso"
    "--latte" = "latte";     "-l" = "latte"
    "--macchiato" = "macchiato"; "-k" = "macchiato"
    "--capucino" = "capucino"; "-p" = "capucino"
    "--mocha" = "mocha";     "-m" = "mocha"
    "--tea" = "tea";         "-t" = "tea"
}

$orders = @()
$i = 0
while ($i -lt $args.Count) {
    $arg = $args[$i]
    if ($arg -eq "-h" -or $arg -eq "-?" -or $arg -eq "--help") {
        # Console.Write, not Write-Output, here - Write-Output goes
        #  through PowerShell's own formatting pipeline and adds its
        #  own trailing CRLF on top of whatever's already in the
        #  string, while Console.Write is a raw passthrough.
        [Console]::Out.Write($usage)
        exit 0
    } elseif ($flags.ContainsKey($arg)) {
        $name = $flags[$arg]
        $n = [int]$args[$i + 1]
        $suffix = if ($n -eq 1) { "" } else { "s" }
        $orders += "$n $name$suffix"
        $i += 2
    } else {
        [Console]::Error.Write($usage)
        exit 1
    }
}

if ($orders.Count -eq 0) {
    [Console]::Error.Write($usage)
    exit 1
}

Write-Output ""
Write-Output "You ordered: "
foreach ($order in $orders) {
    Write-Output "* $order"
}
