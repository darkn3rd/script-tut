#!/usr/bin/env ruby
drinks = {
  "Capucino" => 0,
  "Coffee" => 0,
  "Espresso" => 0,
  "Latte" => 0,
  "Machiato" => 0,
  "Mocha" => 0,
  "Tea" => 0,
}

if ARGV.empty?
  drinks.each_key { |key| drinks[key] = rand(3) }
else
  ARGV.each do |pair|
    key, qty = pair.split(":", 2)
    drinks[key] = qty.to_i
  end
end

order = drinks.sort.select { |_, qty| qty != 0 }.map { |key, qty| "#{key}:#{qty}" }.join(",")

ENV["MY_ORDERS"] = order

# Dump the whole environment (plain "KEY=value" lines) to a well-known
#  file for an external observer to inspect while this script is
#  paused below - deleted again once that observer is done and this
#  script is about to exit.
File.open("dump_env.out", "w") do |f|
  ENV.each { |key, value| f.puts "#{key}=#{value}" }
end

# Explicit flush - stdout is block-buffered (not line-buffered) once
#  it's a pipe rather than a real terminal, so without this the prompt
#  below might never actually reach the test harness waiting to read it.
puts "MY_ORDERS set, Hit Return to continue"
$stdout.flush
# STDIN.gets, not bare gets - bare gets reads from ARGF, which treats
#  any non-empty ARGV entries (our own "Key:Qty" arguments) as
#  filenames to open rather than actual standard input.
STDIN.gets

File.delete("dump_env.out")
