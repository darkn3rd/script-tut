#!/usr/bin/env tclsh
# create populated list
set nicknames [list bob ed steve ralph joe deb kate] 
# enumerate list one element at a time
puts "The names are: "
foreach name $nicknames {
    puts  " $name"
}
