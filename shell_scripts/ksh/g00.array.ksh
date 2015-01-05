#!/usr/bin/env ksh
# insert one by one into array
nicknames[0]=bob
nicknames[1]=ed
nicknames[2]=steve
nicknames[3]=ralph
nicknames[4]=joe
nicknames[5]=deb
nicknames[6]=kate

# output number of elements and enumerated array
print "The number of nicknames is ${#nicknames[*]}"
print "The nicknames are: ${nicknames[*]}"
