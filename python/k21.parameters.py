#!/usr/bin/python

# **************************************
# swapper - swaps contents of two lists
#
# Arguments:
#    a - left-most list 
#    b - right-most list
# **************************************
def swapper(a,b):
    a[:],b[:] = b[:],a[:]

# Create intial variables to be swapped
left=0
right=1

# Package up variables so they can be swapped
#   essentially, we need to store these in a memory referenced object
left_container  = [left]
right_container = [right]

# Output Status before the swap
print("The values are: Left={}, Right={}".format(left,right))

# Perform the Actual Swap
swapper(left_container, right_container)

# Unpackage variables back to their originals
#  Essentially, we fetch the values from the memory referenced object
left = left_container[0]
right = right_container[0]

# Output Status after the swap
print("The values are: Left={}, Right={}".format(left,right))