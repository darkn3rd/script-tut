#!/bin/awk -f
BEGIN    { printf "Enter a name: "
           getline name
           print "Hello " name }
