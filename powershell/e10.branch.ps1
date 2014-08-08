#!/usr/bin/env pash
# get input from user
$response = Read-Host "Would you like a toast? [Yes/No]"

# set response string using one line (ternary-like statement)
#   Test response to a string
$response_str = @( "How about a muffin?", "That's great!")[$response -eq "Yes"] 

# output the response string
$response_str