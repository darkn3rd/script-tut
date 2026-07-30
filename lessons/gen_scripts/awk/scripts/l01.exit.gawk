#!/usr/bin/env -S gawk -f

# function to show usage message
function usage_message()
{
    printf "\nYou need to enter one or more numbers:\n\n" > "/dev/stderr"
    printf "   Usage: %s [num1] [num2] [num3]...\n\n", SCRIPT_NAME > "/dev/stderr"

    exit EX_USAGE                 # exit script indicating usage problem
}

# function to add up numbers
function add_nums(numbers)
{
   sum = 0                        # initialize to 0
   for (num in numbers) {
     sum += numbers[num]          # add all nums in array
   }

   print "The summation is: " sum "." # output results

   exit EX_OK                     # exit program with success status
}

BEGIN {
    # illustrative variables
    ARG_COUNT = ARGC - 1   # get num of arguments
    EX_USAGE  = 64         # status for command line usage error
    EX_OK     = 0          # status for successful termination

    # ARGV[0] is just "gawk", not the -f script name (gawk gives no direct
    #  variable for it). PROCINFO["argv"] is a gawk extension holding the
    #  full raw command line, so scan it for the argument after "-f".
    for (i = 0; i < length(PROCINFO["argv"]); i++) {
      if (PROCINFO["argv"][i] == "-f") {
        SCRIPT_NAME = PROCINFO["argv"][i+1]
        break
      }
    }

    if (ARG_COUNT < 1) {
        usage_message() # output usage statement to standard error
    } else {
        shift(ARGV)     # shift out SCRIPT_NAME from top of array
        add_nums(ARGV)  # call subroutine to output summation of arguments
    }
}

# ==================== HELPER FUNCTIONS ==================== #
# Helper Functions as Awk has no method to shift out elements of array

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
