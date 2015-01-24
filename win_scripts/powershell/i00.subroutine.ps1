#!/usr/bin/env pash
# create function (subroutine)
Function Show-Date
{
   $date = Get-Date -UFormat "%B %d, %Y"
   Write-Host "Today is $date."
}

# call function (subroutine)
Show-Date
