#!/usr/bin/env bash

# get input from user
printf "%s" "Would you like a toast? [Yes/No]: "
read response

# set response string using one command line 
response_str=$( [[ "$response" = "Yes" ]] &&   # test response
	            echo "That's great!" ||        # if true  
	            echo "How about a muffin?"     # if false
	          )

# output the response string
echo $response_str
