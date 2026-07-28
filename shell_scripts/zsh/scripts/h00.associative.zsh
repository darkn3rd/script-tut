#!/usr/bin/env zsh
# declare and initialize empty associative array
declare -A ages

# add key/value pair one by one
ages[bob]=34
ages[ed]=58
ages[steve]=32
ages[ralph]=23
ages[deb]=46
ages[kate]=19

# print all keys and values
# zsh has no "${!array[@]}" (bash's "list the keys" syntax) - that's a
#  bad substitution here; the zsh equivalent is the "(k)" parameter flag
keys=$(printf ", %s" "${(k)ages[@]}")   # join with ", " separator
values=$(printf ", %s" "${ages[@]}")  # join with ", " separator
echo "Keys (names):  ${keys:2}"
echo "Values (ages): ${values:2}"
