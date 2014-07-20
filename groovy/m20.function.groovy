#!/usr/bin/env groovy

// create the function
def sort_array (array) {
   array.sort()  // return list
}

// initialize initial array (list)
array = ["bob","ed","steve","ralph","joe","deb","kate"]
// output current list before calling function
println "Current names are: $array" 

// call the function
result = sort_array(array)

// output the result
println "Sorted names are:  $result" 
