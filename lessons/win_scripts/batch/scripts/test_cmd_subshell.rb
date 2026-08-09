#!/usr/bin/ruby
cmd_str="cmd //c a00.output.cmd"
RESULT = `#{cmd_str}`

puts RUBY_PLATFORM
p RESULT
p RESULT.bytes


