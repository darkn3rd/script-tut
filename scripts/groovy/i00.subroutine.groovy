#!/usr/bin/env groovy

// create subroutine
def showDate() {
   println "Today is ${new Date().format('MMMM dd, yyyy')}."
}

// call the subroutine
showDate()
