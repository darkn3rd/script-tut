#!/bin/gawk -f

# function to show usage message
function show_message()
{
    printf "\nYou need to enter one or more numbers: \n\n" > "/dev/stderr"
    printf "   Usage: %s [num1] [num2] [num3]...\n\n", SCRIPT_NAME > "/dev/stderr"

    exit EX_USAGE                 # exit script indicating usage problem
}

# function to add up numbers
function add_nums(numbers)
{
   sum = 0                        # initalize to 0
   for (num in numbers) { 
     sum += numbers[num]          # add all nums in array 
   }
 
   print "The summation is: " sum # output results

   exit EX_OK                     # exit program with success status
}

BEGIN {
    # illustrative variables
    ARG_COUNT   = ARGC - 1 # get num of arguments
    SCRIPT_NAME = ARGV[0]  # get script name
    EX_USAGE    = 64       # status for command line usage error
    EX_OK       = 0        # status for successful termination

    if (ARG_COUNT < 1) {
        show_message() # output usage statement to standard error
    } else {
        shift(ARGV)    # shift out SCRIPT_NAME from top of array
        add_nums(ARGV) # call subroutine to output summation of arguments
    }
}

# ========== HELPER FUNCTIONS ========== #

# **************************************
# shift (array) - shifts out top of array
# **************************************
function shift(array)
{
    end = length(array) - 1      # end of new array is one less current array
 
    for (i = 0; i < end; i++) {
        array[i] = array[i+1]    # move values up by one
    }

    delete array[i]              # delete last element from array
}