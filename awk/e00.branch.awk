#!/usr/bin/env awk -f
BEGIN {
  # get input from user
  printf "Would you like a toast? [Yes/No]: " # print prompt without newline
  getline response                            # grab input

  # set response string using if/else construction
  #   Test response to a string
  if (response == "Yes") {
    response_str = "That's great!"
  } else {
    response_str = "How about a muffin?"
  }

  # output the response string
  print response_str
}
