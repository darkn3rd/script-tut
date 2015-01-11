#!/usr/bin/env python
# get input from user
response = raw_input("Would you like a toast? [Yes/No]: ")

# set response string using if/else construction
#   Test response to a string
if response == "Yes":
  response_str = "That's great!"
else:
  response_str = "How about a muffin?"

# output the response string
print response_str