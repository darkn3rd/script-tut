#!/usr/bin/env tcsh
echo -n "Enter your name: " # print prompt & acquire input
set name=$<                 # acquire input
echo Hello $name!           # output result using variable
