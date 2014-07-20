#!/usr/bin/env groovy
// illustrative variables 
ARG_COUNT = args.size()   // get number arguments
LAST      = ARG_COUNT - 1 // set index of last item
FIRST     = 0             // set index of first item

println "The arugments passed are:"
// use collection loop with range to enumerate arguments
for (count in LAST..FIRST) {   // range to gen sequence of nums
   arg = args[count]           // get arg using index
   // output count and argument using count index
   println " item ${count+1}: $arg"
}