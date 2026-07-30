#!/usr/bin/env groovy
ages = [:]          // create an empty dictionary

// populate dictionary one item at a time
ages['bob']   = 34
ages['ed']    = 58
ages['steve'] = 32
ages['ralph'] = 23
ages['deb']   = 46
ages['kate']  = 19

// output all keys and values in list
//   only strip the surrounding brackets; keep the ", " separators that
//   List.toString() already produces
println "Keys (names):  ${ages.keySet().toString().replaceAll(/[\]\[]/, "")}"
println "Values (ages): ${ages.values().toString().replaceAll(/[\]\[]/, "")}"
