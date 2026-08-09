RESULT = IO.popen(
 ["cscript", "//NoLogo", "a00.output.vbs"],
 "rt",
 &:read
)

p RUBY_PLATFORM
p RESULT
p RESULT.bytes
