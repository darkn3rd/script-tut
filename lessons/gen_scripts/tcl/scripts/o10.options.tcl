#!/usr/bin/env tclsh
set usage "
Usage: $argv0 \[-c\] \[-e\] \[-l\] \[-k\] \[-p\] \[-m\] \[-t\] \[-h|-?\]

  -c  Coffee
  -e  Espresso
  -l  Latte
  -k  Machiato
  -p  Capucino
  -m  Mocha
  -t  Tea
  -h  Display this help message
  -?  Display this help message

"

array set flags {
  "-c" "coffee"
  "-e" "espresso"
  "-l" "latte"
  "-k" "macchiato"
  "-p" "capucino"
  "-m" "mocha"
  "-t" "tea"
}

set orders {}
foreach arg $argv {
  if {$arg eq "-h" || $arg eq "-?"} {
    puts -nonewline $usage
    exit 0
  } elseif {[info exists flags($arg)]} {
    lappend orders $flags($arg)
  }
}

if {[llength $orders] == 0} {
  puts -nonewline stderr $usage
  exit 1
}

puts ""
puts "You ordered: "
foreach drink $orders {
  puts "* $drink"
}
