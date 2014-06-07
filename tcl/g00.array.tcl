#!/usr/bin/tclsh
# create empty list
set nicknames [list]  
# insert elements by index
set nicknames [linsert $nicknames 0 bob]
set nicknames [linsert $nicknames 1 ed]
set nicknames [linsert $nicknames 2 steve]
set nicknames [linsert $nicknames 3 ralph]
set nicknames [linsert $nicknames 4 joe]
set nicknames [linsert $nicknames 5 deb]
set nicknames [linsert $nicknames 6 kate]
  
# print length
puts "The total nicknames are: [llength $nicknames]"
# enumerate full list
puts "The nicknames are:  [lrange $nicknames 0 end]"
