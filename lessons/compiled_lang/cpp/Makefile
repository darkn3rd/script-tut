# Builds every src/a00.output.cpp-style lesson in this directory into
# bin/a00.output (or bin/a00.output.exe on Windows) - see ../README.md
# for the convention this follows and why.
#
# Two-stage, unlike a single `g++ src.cpp -o bin/out`: the compiled
# object file lands in target/, and only the final linked executable
# gets promoted into bin/, so bin/ holds nothing but runnable
# executables (see ../README.md's Directory Structure section).

include ../common.mk

ifeq ($(ON_WINDOWS),1)
  EXE := .exe
else
  EXE :=
endif

CXX := g++
CXXFLAGS := -std=c++17 -O2 -Wall

# On Windows, multiple MinGW toolchains (Git for Windows, Strawberry
#  Perl, MSYS2 itself, ...) each ship their own libstdc++-6.dll /
#  libgcc_s_seh-1.dll, and PATH order among them varies per shell/tool -
#  a binary can end up loading a mismatched copy of the DLL from a
#  *different* toolchain than the one that compiled it, missing symbols
#  the compiling toolchain relied on (STATUS_ENTRYPOINT_NOT_FOUND at
#  launch, with zero output since the process never reaches main() -
#  observed on the std::filesystem-using f0x lessons, whose ABI surface
#  happens to be sensitive to this; simpler lessons' more stable symbol
#  set silently tolerates whichever copy loads). Statically linking the
#  runtime removes the DLL search - and thus the ambiguity - entirely.
ifeq ($(ON_WINDOWS),1)
  CXXFLAGS += -static-libgcc -static-libstdc++
endif

SRC := $(wildcard src/*.cpp)
BIN := $(addprefix bin/,$(notdir $(SRC:.cpp=$(EXE))))

.PHONY: all clean
all: $(BIN)

# Without this, GNU Make treats target/%.o as a disposable intermediate
#  of the target/%.o -> bin/%$(EXE) chain below and silently deletes
#  each one right after linking - defeating the point of keeping build
#  objects in target/ at all.
.SECONDARY:

bin:
	-@mkdir bin

target:
	-@mkdir target

target/%.o: src/%.cpp | target
	$(CXX) $(CXXFLAGS) -c -o $@ $<

bin/%$(EXE): target/%.o | bin
	$(CXX) $(CXXFLAGS) -o $@ $<

clean:
	rm -f $(BIN)
	rm -rf target
	@mkdir -p target
	@touch target/.gitkeep
