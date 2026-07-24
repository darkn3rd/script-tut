# Builds every a00.output.java-style lesson in this directory into a
# runnable launcher at bin/a00.output (or bin/a00.output.bat on
# Windows) - see ../README.md for the convention this follows and why.
#
# javac's own output naming is tied to the *class name* declared inside
# the file, not the source file name (a00.output.java might produce
# A00Output.class) - java has no single-file "compile straight to a
# named native binary" story the way go/rustc/g++ do. So instead of a
# real binary, each lesson gets a tiny launcher in bin/ (alongside the
# .class file javac produces there too) that runs `java -cp . ClassName`
# - a POSIX shell script on real Unix, a .bat wrapper on Windows
# (recipes here run through sh.exe either way - see ../README.md - only
# the *generated launcher's* own format differs by platform, since
# that's what the test harness actually executes).
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

SRC := $(wildcard *.java)
BIN := $(addprefix bin/,$(SRC:.java=$(WRAPEXT)))

.PHONY: all clean
all: $(BIN)

bin:
	-@mkdir bin

bin/%$(WRAPEXT): %.java | bin
	javac -d bin $<
	class=$$(grep -oE '(^|[^A-Za-z0-9_])class[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' $< | head -1 | sed -E 's/.*class[[:space:]]+//'); \
	if [ "$(ON_WINDOWS)" = "1" ]; then \
	  printf '@echo off\r\njava -cp "%%~dp0." %s %%*\r\n' "$$class" > $@; \
	else \
	  printf '#!/bin/sh\nexec java -cp "$$(dirname "$$0")" %s "$$@"\n' "$$class" > $@; \
	  chmod +x $@; \
	fi

clean:
	rm -f bin/*.class $(BIN)
