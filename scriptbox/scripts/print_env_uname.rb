#!/usr/bin/env ruby
# print_env_uname.rb - prints the exact uname string this machine
#  generates (see verify_commands.rb's own uname_string) and whether
#  config/env.yml already recognizes it - so adding support for a new
#  distro (Zorin, Mint, ...) means running this script *there* and
#  copying its output, rather than hand-guessing the "linux_<id>.<ver>"
#  shape uname_string/match_platform actually expect. Requires (not
#  shells out to) verify_commands.rb, so this can never drift from what
#  the real report actually computes.
#
#  Usage: ruby print_env_uname.rb

require_relative 'verify_commands'

uname = uname_string
platform = match_platform(uname)

puts "Uname string: #{uname}"
if platform
  puts "Already recognized as platform: #{platform} - no config/env.yml change needed."
else
  puts 'Not recognized by any platform in config/env.yml yet.'
  puts 'Add this line under the right platform\'s "supports:" list:'
  puts "  - #{uname}"
end
