#!/usr/bin/env python3
ages = {}          # create an empty dictionary

# populate dictionary one item at a time
ages['bob']=34
ages['ed']=58
ages['steve']=32
ages['ralph']=23
ages['deb']=46
ages['kate']=19

# output all keys and values in list
#   Note: Python 3's dict.keys()/values() return view objects, so we
#   wrap them in list() to enumerate them as a list, like Python 2 did.
print("Keys (names): ", list(ages.keys()))
print("Values (ages): ", list(ages.values()))
