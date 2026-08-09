#!/usr/bin/ruby
cmd_str="cscript //NoLogo a00.output.vbs"
RESULT = `#{cmd_str}`

puts RUBY_PLATFORM
p RESULT
p RESULT.bytes


