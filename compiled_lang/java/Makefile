# Builds every src/a00.output.java-style lesson in this directory into a
# runnable launcher at bin/a00.output (or bin/a00.output.bat on
# Windows) - see ../README.md for the convention this follows and why.
#
# javac's own output naming is tied to the *class name* declared inside
# the file, not the source file name (a00.output.java might produce
# A00Output.class) - java has no single-file "compile straight to a
# named native binary" story the way go/rustc/g++ do. So instead of a
# real binary, each lesson gets a tiny launcher in bin/ that runs
# `java -cp <classdir> ClassName` - a POSIX shell script on real Unix, a
# .bat wrapper on Windows (see ../README.md - only the *generated
# launcher's* own format differs by platform, since that's what the
# test harness actually executes; gen_launcher.rb, which writes it, is
# plain Ruby - see that file for why).
# The .class file itself goes to target/, not bin/ - only the launcher,
# the thing actually meant to be run, lives in bin/ (see ../README.md's
# Directory Structure section); the launcher's own classpath points at
# "../target" (relative to itself) to find it there.
# ".bat", not ".cmd": :cmd (Batch, under win_scripts/batch) already owns
# ".cmd" as its own lesson source extension - reusing it here made a
# Java wrapper indistinguishable from an actual Batch lesson file to the
# test harness's language auto-detection.

include ../common.mk

ifeq ($(ON_WINDOWS),1)
  WRAPEXT := .bat
else
  WRAPEXT :=
endif

SRC := $(wildcard src/*.java)
BIN := $(addprefix bin/,$(notdir $(SRC:.java=$(WRAPEXT))))

.PHONY: all clean
all: $(BIN)

bin:
	-@mkdir bin

target:
	-@mkdir target

bin/%$(WRAPEXT): src/%.java | bin target
	javac -d target $<
	ruby gen_launcher.rb $< $@ $(ON_WINDOWS)

# rm/mkdir/touch aren't reliably available as real executables (Make's
#  own $(SHELL) auto-detection resolves to a real POSIX sh.exe when
#  one's on PATH, but silently falls back to cmd.exe otherwise - e.g. a
#  plain PowerShell session with no MSYS2/Git-bash on PATH at all -
#  confirmed directly), and cmd.exe's own del/rmdir/type builtins bring
#  their own cross-shell escaping/quoting hazards when a *different*
#  shell is the one actually tokenizing this recipe line (also
#  confirmed directly, more than once). `ruby`, unlike either of those,
#  is already a hard requirement for this whole project (the test
#  harness needs it) and its own file operations don't care what shell
#  launched it - so this shells out to a small Ruby one-liner instead
#  of trying to guess which native tool/shell combination is safe.
#  Written with no `$`, backticks, `|`, or nested double quotes, so the
#  single double-quoted argument passes through unmolested whether a
#  POSIX shell or cmd.exe itself is doing the tokenizing - confirmed
#  directly under both.
clean:
	ruby -e "require 'fileutils';File.delete(*Dir.glob('bin/*')) rescue nil;FileUtils.rm_rf('target');FileUtils.mkdir_p('target');FileUtils.touch('target/.gitkeep')"
