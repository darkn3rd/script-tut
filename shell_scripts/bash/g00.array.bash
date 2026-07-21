#!/usr/bin/env bash
# assign items to array
nicknames[0]=bob
nicknames[1]=ed
nicknames[2]=steve
nicknames[3]=ralph
nicknames[4]=joe
nicknames[5]=deb
nicknames[6]=kate

echo "The total nicknames are: ${#nicknames[*]}"  # print length of array
joined=$(printf ", %s" "${nicknames[@]}")         # join with ", " separator
echo "The nicknames are: ${joined:2}"             # enumerate array
