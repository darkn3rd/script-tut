#!/bin/ksh
# declare initial empty associative array
typeset -A ages
 
# initialize associative array some some elements
ages=([bob]=34 [ed]=58 [steve]=32 [ralph]=23)
 
# append another associative array (requires ksh93j or greater)
ages+= ([deb]=46 [kate]=19)
 
# output results
print "The ages are: "
# use collection loop with list of keys
for name in ${!ages[@]}
do
  print "  ages[$name]=${ages[$name]}"
done
