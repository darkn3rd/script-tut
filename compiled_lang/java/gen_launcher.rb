# Generates bin/*'s launcher (see Makefile) - a tiny wrapper that runs
# `java -cp <classdir> ClassName`. A Ruby script, not grep/sed/printf
# chained through the recipe's own shell: those aren't reliably
# available as real executables (Make's $(SHELL) auto-detection falls
# back to cmd.exe, with none of them, when no POSIX shell is reachable
# on PATH - confirmed directly), while `ruby` is already a hard
# requirement for this whole project.
src, dest, on_windows = ARGV

# Matches javac's own naming rule: whichever "class Name" declaration
# actually appears in the file is what javac names the .class file
# after - not preceded by an identifier character, so "class Foo" is
# matched but "superclass Foo" (mid-identifier) is not.
class_name = File.read(src)[/(?:^|[^A-Za-z0-9_])class\s+([A-Za-z_]\w*)/, 1]

if on_windows == "1"
  File.write(dest, "@echo off\r\njava -Dinvoked.as=\"%~0\" -cp \"%~dp0../target\" #{class_name} %*\r\n")
else
  File.write(dest, "#!/bin/sh\nexec java -Dinvoked.as=\"$0\" -cp \"$(dirname \"$0\")/../target\" #{class_name} \"$@\"\n")
  File.chmod(0o755, dest)
end
