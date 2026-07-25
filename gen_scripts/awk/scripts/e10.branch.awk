#!/usr/bin/env awk -f
BEGIN {
  # get input from user
  printf "Would you like a toast? [Yes/No]: " # print prompt without newline
  getline response                            # grab input

  # set response string using if/else construction
  #   Test response to a string
  response_str = (response == "Yes") ? "That's great!" : "How about a muffin?"

  # output the response string
  print response_str
}
