#!/bin/ksh
# required to declare array type
typeset -A ages
 
# individually build array
ages[bob]=34
ages[ed]=58
ages[steve]=32
ages[ralph]=23
ages[deb]=46
ages[kate]=19
 
# print all keys and values
print "Keys  (names): ${!ages[@]}"
print "Values (ages): ${ages[@]}"
