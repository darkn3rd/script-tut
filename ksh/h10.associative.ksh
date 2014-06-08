#!/bin/ksh
# need to declare array type
typeset -A ages
 
# create initial associative array
ages=([bob]=34 [ed]=58 [steve]=32 [ralph]=23)
 
# Add more with ksh93j
ages+= ([deb]=46 [kate]=19)
 
# Print Key/Value Pairs
print "The ages are: "
for name in ${!ages[@]}
do
  print "  ages[$name]=${ages[$name]}"
done
