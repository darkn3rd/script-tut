#!/usr/bin/env python3
# declare the variables
num    = 5                   # python int datatype
char   = 'a'                 # python string datatype
string = "This is a string"  # python string datatype

# output variables using f-strings (formatted string literals) with
#  explicit format specifiers - distinct from the % operator (b10) and
#  the format() method (b11)
print(f"Number is {num:d}.")
print(f"Character is '{char:s}'.")
print(f'String is "{string:s}".')
