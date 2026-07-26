#!/usr/bin/env ruby
# OptionParser can't easily be told "collect flags in the order they
#  were given, allowing repeats" - it fills one fixed destination per
#  flag - so this is parsed by hand instead, matching the technique
#  used across every other language's o20 lesson.
usage = <<END

Usage: #{$0} [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]

  --coffee,    -c N  Coffee
  --espresso,  -e N  Espresso
  --latte,     -l N  Latte
  --macchiato, -k N  Machiato
  --capucino,  -p N  Capucino
  --mocha,     -m N  Mocha
  --tea,       -t N  Tea
  --help,      -h    Display this help message
  -?                 Display this help message

END

flags = {
  "--coffee" => "coffee", "-c" => "coffee",
  "--espresso" => "espresso", "-e" => "espresso",
  "--latte" => "latte", "-l" => "latte",
  "--macchiato" => "macchiato", "-k" => "macchiato",
  "--capucino" => "capucino", "-p" => "capucino",
  "--mocha" => "mocha", "-m" => "mocha",
  "--tea" => "tea", "-t" => "tea",
}

orders = []
i = 0
while i < ARGV.length
  arg = ARGV[i]
  if arg == "--help" || arg == "-h" || arg == "-?"
    print usage
    exit 0
  elsif flags.key?(arg)
    name = flags[arg]
    n = ARGV[i + 1].to_i
    orders << "#{n} " + (n == 1 ? name : "#{name}s")
    i += 2
  else
    $stderr.print usage
    exit 1
  end
end

if orders.empty?
  $stderr.print usage
  exit 1
end

puts ""
puts "You ordered: "
orders.each do |order|
  puts "* #{order}"
end
