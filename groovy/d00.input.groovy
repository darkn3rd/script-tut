#!/usr/bin/env groovy
// get input from user and store as name variable
name = System.console().readLine "Enter your name: "

// output variable
printf "Hello %s!\n", name