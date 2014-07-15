#!/usr/bin/python

# sort function that returns a sorted array
def sort_array (array):
   return sorted(array)  # return list

# initialize initial array (list)
array = ["bob","ed","steve","ralph","joe","deb","kate"]
# output current list before calling function
print "Current names are: ", array

# initialize new array from output of function
result = sort_array(array)
print "Sorted names are:  ", result