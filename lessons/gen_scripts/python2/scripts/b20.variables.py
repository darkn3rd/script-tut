#!/usr/bin/env python2
# declare the variables
num    = 5                   # python int datatype
char   = 'a'                 # python string datatype
string = "This is a string"  # python string datatype

# output variables using the format() method with explicit format
#  specifiers - python 2 has no f-strings (see python3's b20 lesson),
#  but format() (see b11) supports the same format spec mini-language
print "Number is {0:d}.".format(num)
print "Character is '{0:s}'.".format(char)
print 'String is "{0:s}".'.format(string)
