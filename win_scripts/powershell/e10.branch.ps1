#!/usr/bin/env pash
# get input from user
# Read-Host echoes back piped/redirected input - see d00.input.ps1
Write-Host -NoNewline "Would you like a toast? [Yes/No]: "
$response = [Console]::In.ReadLine()

# set response string using one line (alternative to emulate ternary statement)
#  NOTE: This utilizes anonymoous array and slice comprehension to select 0 or 1
#    from the anonymous array and save it as the response.
#  Test response to a string
$response_str = @( "How about a muffin?", "That's great!")[$response -eq "Yes"] 

# output the response string
$response_str