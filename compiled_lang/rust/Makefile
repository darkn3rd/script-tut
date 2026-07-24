# Builds every a00.output.rs-style lesson in this directory into
# bin/a00.output (or bin/a00.output.exe on Windows) - see ../README.md
# for the convention this follows and why.

include ../common.mk

ifeq ($(ON_WINDOWS),1)
  EXE := .exe
else
  EXE :=
endif

SRC := $(wildcard *.rs)
BIN := $(addprefix bin/,$(SRC:.rs=$(EXE)))

.PHONY: all clean
all: $(BIN)

bin:
	-@mkdir bin

bin/%$(EXE): %.rs | bin
	rustc -O --crate-name $(subst .,_,$*) -o $@ $<

clean:
	rm -f $(BIN)
