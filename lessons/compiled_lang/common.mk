# Shared OS detection for lessons/compiled_lang/*/Makefile - see README.md.
#
# $(OS) alone isn't reliable: it's set in the native Windows environment
# block, and a native-Windows make (e.g. Strawberry Perl's mingw32-make)
# sees it fine - but MSYS2's own POSIX-emulation layer doesn't always
# forward it to an MSYS2-native `make` (e.g. `pacman -S make`, the one
# these READMEs tell you to install). Confirmed directly: MSYS2's make
# reports $(OS) as empty even run from a bash session where $OS is
# clearly "Windows_NT". `uname -s` is what actually works reliably
# there, so check both rather than trusting either alone.
UNAME_S := $(shell uname -s 2>/dev/null)
ifeq ($(OS),Windows_NT)
  ON_WINDOWS := 1
else ifneq (,$(findstring MINGW,$(UNAME_S)))
  ON_WINDOWS := 1
else ifneq (,$(findstring MSYS,$(UNAME_S)))
  ON_WINDOWS := 1
else ifneq (,$(findstring CYGWIN,$(UNAME_S)))
  ON_WINDOWS := 1
else
  ON_WINDOWS :=
endif
