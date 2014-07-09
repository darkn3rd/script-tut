#!/usr/bin/tclsh
# illustrative variables
set arg_count   $argc;  # get num of arguments
set script_name $argv0; # get script name
set EX_USAGE    64;     # status for command line usage error
set EX_OK       0;      # status for successful termination

# **************************************
# usageMessage 
#
#   Output instructions to utilize script to standard error
#   and then exit program with appropriate POSIX error code.
#
# **************************************
proc usageMessage {} {
    global script_name  ;# access global illustrative variable
    global EX_USAGE     ;# access global exit status

    # print usage statement to standard error
    puts stderr "\nYou need to one or more numbers: \n"
    puts stderr "   Usage: $script_name \[num1\] \[num2\] \[num2\]...\n"

    # exit program with appropriate error code
    exit $EX_USAGE
}

# **************************************
# addNums
#
#   Output summation of all numbers passed by caller. 
#
# Arguments:
#    args    (required) array of numbers to be processed
#
# **************************************
proc addNums {args} {
    # local variables
    set sum 0          ;# initial sum value
    set nums $args     ;# friendlier name for arguments

    # add up all the num in nums array
    foreach num $nums { set sum [expr $sum + $num] }

    # output results of summation
    puts "The sumation is: $sum" 
}

# **************************************
#             main section 
# **************************************
if { $arg_count < 1 } {
    usageMessage      ;# output usage if invalid # of arguments
} else {
    addNums {*}$argv  ;# required {*} to pass a list
}

# exit program with success (default behavior)
exit $EX_OK