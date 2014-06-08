#!/bin/bash
# assign items to array
nicknames[0]=bob
nicknames[1]=ed
nicknames[2]=steve
nicknames[3]=ralph
nicknames[4]=joe
nicknames[5]=deb
nicknames[6]=kate
 
echo "The number of nicknames are: ${#nicknames[*]}"  # print lenght of array
echo "The nicknames are: ${nicknames[*]}"             # enumerate array
