#!/usr/bin/env python2
nicknames = []           # create an empty list

# populate list one item at a time 
nicknames.append("bob")
nicknames.append("ed")
nicknames.append("steve")
nicknames.append("ralph")
nicknames.append("joe")
nicknames.append("deb")
nicknames.append("kate")

# output length and all values
print "The total nicknames are: %d" % len(nicknames)
print "The nicknames are: " + ", ".join(nicknames)
