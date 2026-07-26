#!/usr/bin/env tclsh
array set drinks {
  Capucino 0
  Coffee 0
  Espresso 0
  Latte 0
  Machiato 0
  Mocha 0
  Tea 0
}

if {[llength $argv] == 0} {
  foreach key [array names drinks] {
    set drinks($key) [expr {int(rand() * 3)}]
  }
} else {
  foreach pair $argv {
    set key [lindex [split $pair ":"] 0]
    set qty [lindex [split $pair ":"] 1]
    set drinks($key) $qty
  }
}

set parts {}
foreach key [lsort [array names drinks]] {
  if {$drinks($key) != 0} {
    lappend parts "$key:$drinks($key)"
  }
}
set order [join $parts ","]

# Tcl's "env" array is special-cased by the interpreter itself - unlike
#  a plain array, writing to it actually calls the real setenv()
#  underneath, so this genuinely exports MY_ORDERS.
set env(MY_ORDERS) $order

# Dump the whole environment (plain "KEY=value" lines) to a well-known
#  file for an external observer to inspect while this script is
#  paused below - deleted again once that observer is done and this
#  script is about to exit.
set fh [open "dump_env.out" w]
foreach key [array names env] {
  puts $fh "$key=$env($key)"
}
close $fh

puts "MY_ORDERS set, Hit Return to continue"
flush stdout
gets stdin

file delete dump_env.out
