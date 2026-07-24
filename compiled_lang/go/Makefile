# Builds every a00.output.go-style lesson in this directory into
# bin/a00.output (or bin/a00.output.exe on Windows) - see ../README.md
# for the convention this follows and why.
#
# NOTE: untested in the environment this was written in (no Go toolchain
# installed there) - please verify `make` works here and report back if
# not, especially the go.mod module-mode assumption (see go.mod).

include ../common.mk

ifeq ($(ON_WINDOWS),1)
  EXE := .exe
else
  EXE :=
endif

SRC := $(wildcard *.go)
BIN := $(addprefix bin/,$(SRC:.go=$(EXE)))

.PHONY: all clean
all: $(BIN)

bin:
	-@mkdir bin

bin/%$(EXE): %.go | bin
	go build -o $@ $<

clean:
	rm -f $(BIN)
