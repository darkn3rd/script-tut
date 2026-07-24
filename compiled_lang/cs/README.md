# Scripting Tutorial: C#

See [../README.md](../README.md) for the shared convention (naming, `make`, how `rake` drives the build).

## Install

You need the [.NET SDK](https://dotnet.microsoft.com/download) - not just the runtime.

* **Windows**: the [official installer](https://dotnet.microsoft.com/download), or `winget install Microsoft.DotNet.SDK.10`.
* **macOS**: `brew install dotnet`, or the official installer.
* **Linux**: your distro's package, or the official installer/script.

Confirm it's on PATH, and that it's the SDK (not just the runtime):

```bash
dotnet --version
dotnet --list-sdks
```

If `dotnet --version` fails with something like "no SDKs were found" even though `dotnet` itself exists, only the runtime is installed - you need the SDK specifically.

## Build and run by hand

```bash
cd compiled_lang/cs
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

## Notes

There's no simple, version-independent way to invoke the compiler directly for a single file: a bare `csc` needs either a hand-built list of every BCL reference assembly it needs (fragile - roughly 240 files, and the exact list depends on the installed SDK's version) or Mono as a separate dependency (whose own compiled `.exe` still needs a wrapper to run on real POSIX, or `mono` prefixed by hand). Both were dead ends in practice.

Instead, the Makefile generates a minimal, throwaway `.csproj` for each lesson and builds it with `dotnet build`. A plain console app has zero external package dependencies, so this needs no NuGet/network access - `dotnet build` resolves everything from the installed SDK alone - and it produces a genuine native apphost, not a "needs a host to run it" managed exe, so (unlike the Mono path) no wrapper script is needed on Windows *or* real POSIX. This is the one language here that needs a project file rather than a truly bare single-file compile, but it's generated automatically - you'll never see or touch it.
