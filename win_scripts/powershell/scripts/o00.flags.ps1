#!/usr/bin/env pwsh
# PowerShell won't bind "-?" to any declared parameter (it's not a
#  valid parameter/variable name), so it falls through to $args
#  unbound - checked for separately below.
param(
    [switch]$c,
    [switch]$e,
    [switch]$l,
    [switch]$k,
    [switch]$p,
    [switch]$m,
    [switch]$t,
    [switch]$h
)

$scriptName = $MyInvocation.MyCommand.Name
$showHelp = $h -or ($args -contains "-?")

$usage = @"

Usage: $scriptName [-c|-e|-l|-k|-p|-m|-t] [-h|-?]

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

if ($c) { Write-Output "You ordered a Coffee."; exit 0 }
if ($e) { Write-Output "You ordered an Espresso."; exit 0 }
if ($l) { Write-Output "You ordered a Latte."; exit 0 }
if ($k) { Write-Output "You ordered a Machiato."; exit 0 }
if ($p) { Write-Output "You ordered a Capucino."; exit 0 }
if ($m) { Write-Output "You ordered a Mocha."; exit 0 }
if ($t) { Write-Output "You ordered a Tea."; exit 0 }
# Console.Write, not Write-Output, for both branches below - Write-Output
#  goes through PowerShell's own formatting pipeline and adds its own
#  trailing CRLF on top of whatever's already in the string, while
#  Console.Write is a raw passthrough of exactly what's given.
if ($showHelp) { [Console]::Out.Write($usage); exit 0 }

[Console]::Error.Write($usage)
exit 1
