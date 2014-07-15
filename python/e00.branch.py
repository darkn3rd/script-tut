#!/usr/bin/python
# get input from user
response = raw_input("Would you like a toast? [Yes/No]: ")
# set response string using if/else construction
#   Test response to a string
if response == "Yes":
  response_string = "That's great"
else:
  response_string = "How about a muffin?"
# output the response string
print response_string