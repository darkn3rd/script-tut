#!/usr/bin/env python3
# prompt, get input, and convert to integer
number = int(input("Input a number: "))

# test number range
if number > 0:
  print("Number is greater than 0")
elif number < 0:
  print("Number is less than 0")
else:
  print("Number is 0")
