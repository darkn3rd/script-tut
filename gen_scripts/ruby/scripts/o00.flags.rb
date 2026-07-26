#!/usr/bin/env ruby
usage = <<END

Usage: #{$0} [-c|-e|-l|-k|-p|-m|-t] [-h|-?]

  -c  Coffee
  -e  Espresso
  -l  Latte
  -k  Machiato
  -p  Capucino
  -m  Mocha
  -t  Tea
  -h  Display this help message
  -?  Display this help message

END

case ARGV[0]
when "-c"
  puts "You ordered a Coffee."
  exit 0
when "-e"
  puts "You ordered an Espresso."
  exit 0
when "-l"
  puts "You ordered a Latte."
  exit 0
when "-k"
  puts "You ordered a Machiato."
  exit 0
when "-p"
  puts "You ordered a Capucino."
  exit 0
when "-m"
  puts "You ordered a Mocha."
  exit 0
when "-t"
  puts "You ordered a Tea."
  exit 0
when "-h", "-?"
  print usage
  exit 0
end

$stderr.print usage
exit 1
