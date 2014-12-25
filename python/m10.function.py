#!/usr/bin/env python
import string
# create the function
def capitalize (string):
   return string.upper() # return fully uppercase string

# output string before calling function
string = "ibm"
print "The current string is: \"%s\"." % string

# call the function
result = capitalize(string)

# output results after calling function
print "The capitalized string is: \"%s\"." % result