#!/usr/bin/env tcsh

# declare empty variable
set nicknames = ()

# build array item by item
set nicknames = ( $nicknames "bob")
set nicknames = ( $nicknames "ed")
set nicknames = ( $nicknames "steve")
set nicknames = ( $nicknames "ralph")
set nicknames = ( $nicknames "joe")
set nicknames = ( $nicknames "deb")
set nicknames = ( $nicknames "kate")

# output results
echo The number of nicknames is $#nicknames  # size of array
echo The nicknames are: $nicknames            # enumerate array list
