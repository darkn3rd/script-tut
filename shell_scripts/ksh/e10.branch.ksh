#!/usr/bin/env ksh

# get input from user
read response?"Would you like a toast? [Yes/No]: "

# set response string using one command line 
response_str=$( [[ "$response" = "Yes" ]] &&   # test response
	            echo "That's great!" ||        # if true  
	            echo "How about a muffin?"     # if false
	          )

# output the response string
echo $response_str
