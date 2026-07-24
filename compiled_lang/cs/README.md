# Scripting Tutorial: C#

See [../README.md](../README.md) for the shared convention (naming, `make`, how `rake` drives the build).

**Not yet verified locally** - written the same way as the other four, but there was no working `csc` (Mono or a .NET SDK) in the environment this was set up in (a `dotnet` binary was present with no SDK installed). If `make` doesn't work here, this is the first place to look.

## Install

You need a `csc` (C# compiler) on PATH - not just a `dotnet` runtime.

* **Windows (MSYS2)**: `pacman -S mono`, which provides `csc`; or install the [.NET SDK](https://dotnet.microsoft.com/download) (its `csc` isn't on PATH by default - see below).
* **macOS**: `brew install mono`.
* **Linux**: your distro's Mono package, e.g. `apt install mono-devel`.

Confirm it's on PATH:

```bash
csc /version
```

If you only have the .NET SDK installed and no `csc` on PATH: the SDK bundles its own Roslyn `csc.dll` internally (used by `dotnet build`), but doesn't expose a `csc` command directly - installing Mono alongside is the simplest fix for this project's single-file build model. A modern SDK's own `dotnet run <file>.cs` single-file support is a good way to quickly try a lesson without `make` at all, but doesn't fit this directory's "one named binary per lesson" convention, so the Makefile doesn't use it.

## Build and run by hand

```bash
cd compiled_lang/cs
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

## Notes

Unlike Java, C# has no file-name-must-match-class-name restriction, so `csc /out:a00.output.exe a00.output.cs` produces the named binary directly - no wrapper needed on Windows. On real POSIX, that same `.exe` still needs `mono` to run it (unless your system has registered Mono via `binfmt_misc` for direct `.exe` execution), so the Makefile wraps it in an extension-less launcher script there, the same idea as Java's wrapper.
