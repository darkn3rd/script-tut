# Builds every a00.output.cs-style lesson in this directory into
# bin/a00.output.exe on Windows, or bin/a00.output on real POSIX -
# see ../README.md for the convention this follows and why.
#
# Unlike the other four languages, this doesn't shell out to a bare
# compiler - `csc` needs either a hand-built list of every BCL reference
# assembly (fragile, version-specific, ~240 files) or Mono (an extra
# dependency, and its own compiled .exe still isn't directly runnable on
# real POSIX without a wrapper). Instead, each lesson gets its own
# minimal, throwaway .csproj generated on the fly, built with `dotnet
# build`. A plain console app has zero external package dependencies, so
# this needs no NuGet access - `dotnet build` resolves everything from
# the installed SDK alone - and it produces a genuine native apphost
# (correct on Windows *and* real POSIX), not a "needs a host to run it"
# managed exe, so no wrapper script is needed on either platform (unlike
# java/Makefile, which has no such option at all).

include ../common.mk

ifeq ($(ON_WINDOWS),1)
  OUTEXT := .exe
else
  OUTEXT :=
endif

# e.g. "10.0.302" -> "10.0", used as the generated <TargetFramework>.
DOTNET_TFM := $(shell dotnet --version | cut -d. -f1,2)

SRC := $(wildcard *.cs)
BIN := $(addprefix bin/,$(SRC:.cs=$(OUTEXT)))

.PHONY: all clean
all: $(BIN)

bin:
	-@mkdir bin

bin/%$(OUTEXT): %.cs | bin
	@printf '<Project Sdk="Microsoft.NET.Sdk">\n  <PropertyGroup>\n    <OutputType>Exe</OutputType>\n    <TargetFramework>net$(DOTNET_TFM)</TargetFramework>\n    <ImplicitUsings>disable</ImplicitUsings>\n    <Nullable>disable</Nullable>\n    <EnableDefaultCompileItems>false</EnableDefaultCompileItems>\n    <AssemblyName>$*</AssemblyName>\n    <BaseIntermediateOutputPath>obj/$*/</BaseIntermediateOutputPath>\n  </PropertyGroup>\n  <ItemGroup>\n    <Compile Include="../$*.cs" />\n  </ItemGroup>\n</Project>\n' > bin/$*.csproj
	dotnet build bin/$*.csproj -o bin --nologo -v quiet

clean:
	rm -f $(BIN) bin/*.exe bin/*.dll bin/*.pdb bin/*.deps.json bin/*.runtimeconfig.json bin/*.csproj
	rm -rf bin/obj
