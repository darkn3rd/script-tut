#!/usr/bin/tclsh
# populate full list
set nicknames [list bob ed steve ralph joe deb kate]
# enumerate through list elements by index
puts "The names are: "
for {set count 0} {$count < [llength $nicknames]} {incr count} {
   puts -nonewline " nicknames\[$count\]="
   puts [lindex $nicknames $count]
}
