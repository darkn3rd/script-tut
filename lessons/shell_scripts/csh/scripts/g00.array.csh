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
echo "The total nicknames are: $#nicknames"  # size of array
set joined = `echo $nicknames | sed "s/ /, /g"`
echo "The nicknames are: $joined"            # enumerate array list
