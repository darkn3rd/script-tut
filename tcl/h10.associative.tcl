#!/usr/bin/tclsh
# populate initial array
array set ages {bob 34 ed 58 steve 32 ralph 23}
# append more items into array
array set ages {deb 46 kate 19}
# iterate through array, print key/value pairs
foreach {name age} [array get ages] {
  puts "ages\[$name\]=$age"
}
