#!/usr/bin/env python
# create a populated list
nicknames = ["bob","ed","steve","ralph","joe","deb","kate"]

# output the list with index, one item per line
print "The names are: "
# utitlize count style loop to enumerate list
for count in range(len(nicknames)):
    print " nicknames[%d]=%s" % (count, nicknames[count])