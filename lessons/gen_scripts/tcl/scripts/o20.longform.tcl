#!/usr/bin/env tclsh
# Tcl has no built-in getopt-style parser at all - this is parsed by
#  hand, matching the technique used across every other language's o20
#  lesson.
set usage "
Usage: $argv0 \[--coffee|-c N\] \[--espresso|-e N\] \[--latte|-l N\] \[--macchiato|-k N\] \[--capucino|-p N\] \[--mocha|-m N\] \[--tea|-t N\] \[--help|-h|-?\]

  --coffee,    -c N  Coffee
  --espresso,  -e N  Espresso
  --latte,     -l N  Latte
  --macchiato, -k N  Machiato
  --capucino,  -p N  Capucino
  --mocha,     -m N  Mocha
  --tea,       -t N  Tea
  --help,      -h    Display this help message
  -?                 Display this help message

"

array set flags {
  "--coffee" "coffee"     "-c" "coffee"
  "--espresso" "espresso" "-e" "espresso"
  "--latte" "latte"       "-l" "latte"
  "--macchiato" "macchiato" "-k" "macchiato"
  "--capucino" "capucino" "-p" "capucino"
  "--mocha" "mocha"       "-m" "mocha"
  "--tea" "tea"           "-t" "tea"
}

set orders {}
set i 0
set argc [llength $argv]
while {$i < $argc} {
  set arg [lindex $argv $i]
  if {$arg eq "--help" || $arg eq "-h" || $arg eq "-?"} {
    puts -nonewline $usage
    exit 0
  } elseif {[info exists flags($arg)]} {
    set name $flags($arg)
    set n [lindex $argv [expr {$i + 1}]]
    if {$n == 1} {
      lappend orders "$n $name"
    } else {
      lappend orders "$n ${name}s"
    }
    incr i 2
  } else {
    puts -nonewline stderr $usage
    exit 1
  }
}

if {[llength $orders] == 0} {
  puts -nonewline stderr $usage
  exit 1
}

puts ""
puts "You ordered: "
foreach order $orders {
  puts "* $order"
}
