#!/usr/bin/env zsh
# declare initial empty associative array
declare -A ages

# initialize associative array with elements
ages=([bob]=34 [ed]=58 [steve]=32 [ralph]=23)

# append another associative array
ages+=([deb]=46 [kate]=19)

# output results
echo "The ages are: "
# use collection loop with list of keys
# zsh has no "${!array[@]}" (bash's "list the keys" syntax) - that's a
#  bad substitution here; the zsh equivalent is the "(k)" parameter flag
for name in "${(k)ages[@]}"; do
  echo " ages[$name]=${ages[$name]}"
done
