#!/bin/ksh

# get input from user
read response?"Would you like a toast? [Yes/No]: "

# set response string using if/else construction
#   Test response to a string
if [[ "$response" = "Yes" ]]; then
  response_str="That's great!"
else
  response_str="How about a muffin?"
fi

# output the response string
echo $response_str
