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
# .bat wrapper on Windows (recipes here run through sh.exe either way -
# see ../README.md - only the *generated launcher's* own format differs
# by platform, since that's what the test harness actually executes).
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
	class=$$(grep -oE '(^|[^A-Za-z0-9_])class[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' $< | head -1 | sed -E 's/.*class[[:space:]]+//'); \
	if [ "$(ON_WINDOWS)" = "1" ]; then \
	  printf '@echo off\r\njava -cp "%%~dp0..\\target" %s %%*\r\n' "$$class" > $@; \
	else \
	  printf '#!/bin/sh\nexec java -cp "$$(dirname "$$0")/../target" %s "$$@"\n' "$$class" > $@; \
	  chmod +x $@; \
	fi

clean:
	rm -f $(BIN)
	rm -rf target
	@mkdir -p target
	@touch target/.gitkeep
