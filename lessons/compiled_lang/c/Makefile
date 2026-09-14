# Builds every src/a00.output.c-style lesson in this directory into
# bin/a00.output (or bin/a00.output.exe on Windows) - see ../README.md
# for the convention this follows and why.
#
# Object files are namespaced by $(UNAME_S)_$(ARCH) under target/ (see
# ARCH detection below), unlike the other three languages' flat
# target/ - a plain C build's flags are tuned per architecture (see
# CFLAGS_$(ARCH) below), so a stale object compiled for one
# architecture must never get silently relinked into a binary just
# because its mtime looks up to date. bin/ itself stays flat and
# unnamespaced, matching every sibling language's Makefile (and what
# testbox's Script.rb expects, invoking a fixed "bin/<name>" regardless
# of architecture) - a rebuild for a *different* architecture always
# recompiles its own arch-namespaced object first, so the promoted
# binary in bin/ ends up relinked fresh either way.

include ../common.mk

ifeq ($(ON_WINDOWS),1)
  EXE := .exe
else
  EXE :=
endif

# Overridable from the command line (`make ARCH=arm64`) - e.g. to
# force-test the other branch of CFLAGS_$(ARCH) below without actually
# switching hardware.
ARCH ?= $(shell uname -m)

CC := gcc
CFLAGS := -std=c17 -O2 -Wall -Wextra

# macOS's clang is a universal compiler - explicitly targeting a
#  non-native $(ARCH) here (`make ARCH=arm64` on Intel, or vice versa)
#  actually cross-compiles instead of erroring, confirmed directly:
#  without this, -mcpu=apple-m1 below is rejected outright ("unsupported
#  option ... for target 'x86_64-apple-darwin...'") since the compiler
#  is still implicitly targeting the host's own architecture.
NATIVE_ARCH := $(shell uname -m)
ifeq ($(UNAME_S),Darwin)
  CFLAGS += -arch $(ARCH)
endif

# -march=native tunes for *this exact process's own host CPU* - only
#  meaningful (and only accepted by the compiler at all) when actually
#  building for that same native architecture, never when cross-
#  targeting the other one above - x86-64-v2 is a safe, widely-
#  supported baseline for a cross-built x86_64 binary instead.
# -mcpu=apple-m1 targets the Apple Silicon baseline - clang/gcc treat
#  every later Apple Silicon chip (M2, M3, M4, ...) as binary-compatible
#  with it, so this isn't actually M1-specific despite the flag's name.
ifeq ($(ARCH),$(NATIVE_ARCH))
  CFLAGS_x86_64 := -march=native
else
  CFLAGS_x86_64 := -march=x86-64-v2
endif
CFLAGS_arm64   := -mcpu=apple-m1
CFLAGS_aarch64 := -march=armv8-a
CFLAGS += $(CFLAGS_$(ARCH))

ifeq ($(ON_WINDOWS),1)
  CFLAGS += -static-libgcc
endif

# math.h (c20/c30) needs -lm explicitly on glibc-based Linux; macOS's
# and MinGW-w64's libc fold it into the default link already, but
# passing it everywhere is harmless there too.
LDLIBS := -lm

# Optional Conan-managed dependency - extra.conan_cjson.c demonstrates
# installing a real C library (cJSON) instead of hand-rolling one, see
# ../README.md's "Package Management (Conan)" section. `conan install .`
# generates conandeps.mk; -include is silently skipped when it's
# missing.
CONAN_LIB_FLAG := -l
CONAN_INCLUDE_DIR_FLAG := -I
CONAN_LIB_DIR_FLAG := -L
CONAN_DEFINE_FLAG := -D
-include conandeps.mk
# conandeps.mk's own aggregated variables already have the flag
#  prefixes above baked in (it builds them as e.g.
#  "$(CONAN_INCLUDE_DIR_FLAG)$(CONAN_ROOT_CJSON)/include") - confirmed
#  directly wrapping these in another addprefix double-prefixes them
#  ("-I-I/path", "-l-lcjson") and fails to link.
CFLAGS += $(CONAN_INCLUDE_DIRS)
LDLIBS += $(CONAN_LIB_DIRS) $(CONAN_LIBS)

OBJDIR := target/$(UNAME_S)_$(ARCH)

# extra.conan_cjson.c is excluded from the default build/SRC-BIN glob -
#  it can only link once `conan install` has produced conandeps.mk, and
#  `make`/`make all` (what `rake` runs before every test) must keep
#  succeeding with no Conan involved at all. Build it explicitly with
#  `make conan`.
SRC := $(filter-out src/extra.conan_cjson.c,$(wildcard src/*.c))
BIN := $(addprefix bin/,$(notdir $(SRC:.c=$(EXE))))
CONAN_BIN := bin/extra.conan_cjson$(EXE)

.PHONY: all clean conan
all: $(BIN)

conan: $(CONAN_BIN)

# Without this, GNU Make treats $(OBJDIR)/%.o as a disposable
#  intermediate of the $(OBJDIR)/%.o -> bin/%$(EXE) chain below and
#  silently deletes each one right after linking.
.SECONDARY:

bin:
	-@mkdir bin

target:
	-@mkdir target

# One level below an already-existing target/ - a plain mkdir handles
#  this fine on both POSIX and cmd.exe's builtin, unlike `mkdir -p`
#  itself (see clean's own comment on why -p is never used here).
$(OBJDIR): | target
	-@mkdir $(OBJDIR)

$(OBJDIR)/%.o: src/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

bin/%$(EXE): $(OBJDIR)/%.o | bin
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)

# -@mkdir (no -p, ignore "already exists") - GNU Make's own default
#  recipe shell on native Windows can fall back to cmd.exe, whose
#  *built-in* mkdir has no -p flag at all - see ../cpp/Makefile's own
#  comment for the concrete breakage this caused there.
clean:
	rm -f $(BIN) $(CONAN_BIN)
	rm -rf target
	-@mkdir target
	@touch target/.gitkeep
