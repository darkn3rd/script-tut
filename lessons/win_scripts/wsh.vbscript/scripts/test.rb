#!/usr/bin/ruby
cmd_str="cscript.exe //NoLogo a00.output.vbs"
RESULT = `#{cmd_str}`

puts RUBY_PLATFORM
p RESULT
p RESULT.bytes


