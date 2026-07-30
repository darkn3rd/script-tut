#!/usr/bin/env ruby
usage = <<END

Usage: #{$0} [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]

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

flags = {
  "-c" => "coffee",
  "-e" => "espresso",
  "-l" => "latte",
  "-k" => "macchiato",
  "-p" => "capucino",
  "-m" => "mocha",
  "-t" => "tea",
}

orders = []
ARGV.each do |arg|
  if arg == "-h" || arg == "-?"
    print usage
    exit 0
  elsif flags.key?(arg)
    orders << flags[arg]
  end
end

if orders.empty?
  $stderr.print usage
  exit 1
end

puts ""
puts "You ordered: "
orders.each do |drink|
  puts "* #{drink}"
end
