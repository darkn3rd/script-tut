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
# publish -r <RID>` and Native AOT (<PublishAot>true</PublishAot>).
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
# machine's Runtime Identifier (RID) autodetected below.
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
DOTNET_TFM := $(shell dotnet --version | cut -d. -f1,2)
# e.g. "osx-x64", "linux-x64", "win-x64" - Native AOT has no "any CPU"
#  output, so this has to match whatever machine `make` actually runs
#  on, same as `dotnet --info` itself reports.
DOTNET_RID := $(shell dotnet --info | grep 'RID:' | awk '{print $$NF}')

SRC := $(wildcard src/*.cs)
BIN := $(addprefix bin/,$(notdir $(SRC:.cs=$(OUTEXT))))

.PHONY: all clean
all: $(BIN)

bin:
	-@mkdir bin

target:
	-@mkdir target

bin/%$(OUTEXT): src/%.cs | bin target
	@printf '<Project Sdk="Microsoft.NET.Sdk">\n  <PropertyGroup>\n    <OutputType>Exe</OutputType>\n    <TargetFramework>net$(DOTNET_TFM)</TargetFramework>\n    <ImplicitUsings>disable</ImplicitUsings>\n    <Nullable>disable</Nullable>\n    <EnableDefaultCompileItems>false</EnableDefaultCompileItems>\n    <AssemblyName>$*</AssemblyName>\n    <PublishAot>true</PublishAot>\n    <InvariantGlobalization>true</InvariantGlobalization>\n    <BaseIntermediateOutputPath>obj/$*/</BaseIntermediateOutputPath>\n  </PropertyGroup>\n  <ItemGroup>\n    <Compile Include="../src/$*.cs" />\n  </ItemGroup>\n</Project>\n' > target/$*.csproj
	dotnet publish target/$*.csproj -r $(DOTNET_RID) -o target --nologo -v quiet
	cp target/$*$(OUTEXT) $@

clean:
	rm -f $(BIN)
	rm -rf target
	@mkdir -p target
	@touch target/.gitkeep
