#!/usr/bin/env pash
# prompt user and get input
# Read-Host echoes back piped/redirected input - see d00.input.ps1
Write-Host -NoNewline "Input a number: "
$number = [int]([Console]::In.ReadLine())
# evaluate input and print result
if ( $number -gt 0 ) {
  "Number is greater than 0"
} elseif ( $number -lt 0 ) {
  "Number is less than 0"
} else {
  "Number is 0"
}
