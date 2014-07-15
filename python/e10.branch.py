#!/usr/bin/python
# get input from user
response = raw_input("Would you like a toast? [Yes/No]: ")
# set response string using one line
#   Test response to a string
response_string = "That's great" if response == "Yes" else "How about a muffin?"
# output the response string
print response_string