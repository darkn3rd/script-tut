#!/usr/bin/env pash
# get input from user
# Read-Host echoes back whatever it reads from a redirected/piped stdin,
#  and its automatic prompt+": " doesn't reach captured output the same
#  way when non-interactive - Write-Host + [Console]::In.ReadLine() avoids
#  both problems (Read-Host would normally append ": " to the prompt
#  itself, so that's added explicitly here).
Write-Host -NoNewline "Would you like a toast? [Yes/No]: "
$response = [Console]::In.ReadLine()

# set response string using if/else construction
#   Test response to a string
if ($response -eq "Yes") {
  $response_str = "That's great!"
} else {
  $response_str = "How about a muffin?"
}
# output the response string
$response_str
