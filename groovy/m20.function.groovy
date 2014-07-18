#!/usr/bin/env groovy

# create the function
def sort_array (array):
   return sorted(array)  # return list

# initialize initial array (list)
array = ["bob","ed","steve","ralph","joe","deb","kate"]
# output current list before calling function
print "Current names are: ", array

# call the function
result = sort_array(array)

# output the result
print "Sorted names are:  ", result
