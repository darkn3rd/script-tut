# Builds every src/a00.output.rs-style lesson in this directory into
# bin/a00.output (or bin/a00.output.exe on Windows) - see ../README.md
# for the convention this follows and why.
#
# `rustc` compiles straight to a final binary in one step - there's no
# separate object file to expose the way g++ or cl.exe produce one - so
# it's built directly into target/ first and then promoted into bin/,
# purely to keep the same target/-then-bin/ shape every other language
# here follows (see ../README.md's Directory Structure section); bin/
# still ends up holding nothing but runnable executables.

include ../common.mk

ifeq ($(ON_WINDOWS),1)
  EXE := .exe
else
  EXE :=
endif

SRC := $(wildcard src/*.rs)
BIN := $(addprefix bin/,$(notdir $(SRC:.rs=$(EXE))))

.PHONY: all clean
all: $(BIN)

# Without this, GNU Make treats target/%$(EXE) as a disposable
#  intermediate of the target/%$(EXE) -> bin/%$(EXE) chain below and
#  silently deletes each one right after promoting it - defeating the
#  point of keeping a build copy in target/ at all.
.SECONDARY:

bin:
	-@mkdir bin

target:
	-@mkdir target

target/%$(EXE): src/%.rs | target
	rustc -O --crate-name $(subst .,_,$*) -o $@ $<

bin/%$(EXE): target/%$(EXE) | bin
	@cp $< $@

clean:
	rm -f $(BIN)
	rm -rf target
	@mkdir -p target
	@touch target/.gitkeep
