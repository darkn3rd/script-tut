# Builds every src/a00.output.cs-style lesson in this directory into
# bin/a00.output.exe on Windows, or bin/a00.output on real POSIX -
# see ../README.md for the convention this follows and why.
#
# Unlike the other four languages, this doesn't shell out to a bare
# compiler - `csc` needs either a hand-built list of every BCL reference
# assembly (fragile, version-specific, ~240 files) or Mono (an extra
# dependency, and its own compiled .exe still isn't directly runnable on
# real POSIX without a wrapper). Instead, each lesson gets its own
# minimal, throwaway .csproj generated on the fly, built with `dotnet
# publish` and Native AOT (<PublishAot>true</PublishAot>).
#
# A plain `dotnet build` apphost is *not* actually self-contained - it's
# a small native stub that looks for a same-named .dll (plus
# .runtimeconfig.json/.deps.json) sitting right next to itself, and
# fails immediately without them, unlike every other language here.
# Native AOT fixes that properly: it ahead-of-time compiles straight to
# native machine code, so bin/ ends up with one genuinely standalone
# executable per lesson, same as g++/go/rustc produce - no bundled
# runtime needed at all (unlike a traditional
# <PublishSingleFile>+<SelfContained> publish, which bundles the entire
# .NET runtime into every binary, ~70MB+ each). The tradeoff: AOT needs
# a native linker on top of the SDK - clang/gcc on POSIX (already
# required for cpp/, and present via Xcode Command Line Tools on macOS)
# or the MSVC Build Tools on Windows (already required for cpp/'s own
# MSVC path - see cpp/README.md) - and, since it compiles for one
# specific platform+arch rather than "any CPU", needs the current
# machine's Runtime Identifier (RID) - the generated .csproj below
# sources that from MSBuild's own $(NETCoreSdkRuntimeIdentifier)
# property rather than Make shelling out for it.
#
# Everything `dotnet publish` produces - the generated .csproj, obj/,
# and (on macOS) a .dSYM debug-symbol bundle or (elsewhere) a .pdb -
# lands in target/; only the final native executable gets promoted into
# bin/, so bin/ holds nothing but runnable executables (see
# ../README.md's Directory Structure section).

include ../common.mk

ifeq ($(ON_WINDOWS),1)
  OUTEXT := .exe
else
  OUTEXT :=
endif

# e.g. "10.0.302" -> "10.0", used as the generated <TargetFramework>.
# Pure Make text functions, not `cut`: GNU Make's own shell isn't
#  guaranteed to be a POSIX one (e.g. it falls back to cmd.exe, with no
#  cut/grep/awk builtins, when invoked from a PowerShell session with
#  no MSYS2 usr/bin on PATH) - this works under any shell Make picks.
DOTNET_VERSION := $(shell dotnet --version)
empty :=
space := $(empty) $(empty)
DOTNET_TFM := $(subst $(space),.,$(wordlist 1,2,$(subst ., ,$(DOTNET_VERSION))))

SRC := $(wildcard src/*.cs)
BIN := $(addprefix bin/,$(notdir $(SRC:.cs=$(OUTEXT))))

.PHONY: all clean
all: $(BIN)

bin:
	-@mkdir bin

target:
	-@mkdir target

bin/%$(OUTEXT): src/%.cs | bin target
	@printf '<Project Sdk="Microsoft.NET.Sdk">\n  <PropertyGroup>\n    <OutputType>Exe</OutputType>\n    <TargetFramework>net$(DOTNET_TFM)</TargetFramework>\n    <RuntimeIdentifier>$$(NETCoreSdkRuntimeIdentifier)</RuntimeIdentifier>\n    <ImplicitUsings>disable</ImplicitUsings>\n    <Nullable>disable</Nullable>\n    <EnableDefaultCompileItems>false</EnableDefaultCompileItems>\n    <AssemblyName>$*</AssemblyName>\n    <PublishAot>true</PublishAot>\n    <InvariantGlobalization>true</InvariantGlobalization>\n  </PropertyGroup>\n  <ItemGroup>\n    <Compile Include="../src/$*.cs" />\n  </ItemGroup>\n</Project>\n' > target/$*.csproj
	dotnet publish target/$*.csproj -o target --nologo -v quiet
	@cp target/$*$(OUTEXT) $@

# -@mkdir, not "@mkdir -p" - see ../cpp/Makefile's own clean: for why
#  (a bare cmd.exe recipe shell's built-in mkdir has no -p flag at
#  all, and silently created a literal "-p" directory instead -
#  confirmed directly, with a genuinely surprising downstream effect
#  on argv parsing).
clean:
	rm -f $(BIN)
	rm -rf target
	-@mkdir target
	@touch target/.gitkeep
