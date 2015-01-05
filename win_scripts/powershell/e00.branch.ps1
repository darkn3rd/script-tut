#!/usr/bin/env pash
# get input from user
$response = Read-Host "Would you like a toast? [Yes/No]"

# set response string using if/else construction
#   Test response to a string
if ($response -eq "Yes") {
  $response_str = "That's great!"
} else {
  $response_str = "How about a muffin?"
}
# output the response string
$response_str