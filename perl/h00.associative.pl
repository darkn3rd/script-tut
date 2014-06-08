#!/usr/bin/perl -w
use strict;
my %ages;           # declare hash
  
# add key/value one by one
$ages{bob}=34;     
$ages{ed}=58;
$ages{steve}=32;
$ages{ralph}=23;
$ages{deb}=46;
$ages{kate}=19;
  
# print keys and values
print "Keys (names): ", join (" ", keys %ages), "\n";
print "Values (ages): ", join (" " , values %ages), "\n";
