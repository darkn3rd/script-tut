# Builds every a00.output.cpp-style lesson in this directory into
# bin/a00.output (or bin/a00.output.exe on Windows) - see ../README.md
# for the convention this follows and why.

include ../common.mk

ifeq ($(ON_WINDOWS),1)
  EXE := .exe
else
  EXE :=
endif

CXX := g++
CXXFLAGS := -std=c++17 -O2 -Wall

SRC := $(wildcard *.cpp)
BIN := $(addprefix bin/,$(SRC:.cpp=$(EXE)))

.PHONY: all clean
all: $(BIN)

bin:
	-@mkdir bin

bin/%$(EXE): %.cpp | bin
	$(CXX) $(CXXFLAGS) -o $@ $<

clean:
	rm -f $(BIN) bin/*.obj
