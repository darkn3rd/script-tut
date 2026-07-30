#!/usr/bin/env tclsh
set usage "
Usage: $argv0 \[-c|-e|-l|-k|-p|-m|-t\] \[-h|-?\]

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

if {[llength $argv] == 1} {
  switch -- [lindex $argv 0] {
    "-c" { puts "You ordered a Coffee."; exit 0 }
    "-e" { puts "You ordered an Espresso."; exit 0 }
    "-l" { puts "You ordered a Latte."; exit 0 }
    "-k" { puts "You ordered a Machiato."; exit 0 }
    "-p" { puts "You ordered a Capucino."; exit 0 }
    "-m" { puts "You ordered a Mocha."; exit 0 }
    "-t" { puts "You ordered a Tea."; exit 0 }
    "-h" - "-?" { puts -nonewline $usage; exit 0 }
  }
}

puts -nonewline stderr $usage
exit 1
