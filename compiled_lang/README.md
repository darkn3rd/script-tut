# Compiled Languages

© Joaquin Menchaca, 2026

## Overview

`compiled_lang` holds implementations of the same lessons as `gen_scripts`/`shell_scripts`/`win_scripts`, but for languages that need a build step first: Java, C#, Go, Rust, and C++. Each lesson is still one source file per test (`a00.output.java`, `a00.output.rs`, ...), but before the test harness can run it, a `Makefile` in that directory has to turn it into something runnable.

## Convention

Every language directory here follows the same shape:

* `Makefile` - builds every lesson source file in the directory into a runnable artifact under `bin/`, named after the source file **minus its language extension**. `a00.output.rs` becomes `bin/a00.output` on macOS/Linux, or `bin/a00.output.exe` on Windows. `bin/` is gitignored (only `bin/.gitkeep` is tracked, so the directory itself exists on a fresh checkout) - `make clean` empties it back out.
* `common.mk` (one level up, shared by all five) - figures out whether the build is targeting Windows or real POSIX, since that decides both the output extension and, for some languages, how the runnable artifact is actually shaped (see below).
* `Rakefile` - a one-liner that imports the shared [testbox](../testbox/README.md) harness, exactly like every other lesson directory.

Java can't produce a real standalone native binary from a single source file, so its Makefile generates a small launcher instead, under the same naming convention:

* **Java** - `javac` output is named after the *class* declared inside the file, not the source file, and there's no single-file "compile to a binary" option. Each lesson's class must **not** be `public` (a `public` class's file name is required to match the class name exactly, which would conflict with this project's dotted lesson-file naming) - see `java/a00.output.java` for the pattern. The Makefile compiles the `.class` file into `bin/` too, then generates a launcher in `bin/`, named after the source (a POSIX shell script, or a `.bat` wrapper on Windows), that runs `java -cp . ClassName`.

C# is the other exception, for a different reason: there's no simple, version-independent way to drive `csc` directly for a single file (see `cs/README.md`), so its Makefile generates a minimal, throwaway `.csproj` per lesson and builds it with `dotnet build` instead - a plain console app needs no NuGet/network access to do this. That produces a genuine native apphost on both Windows and real POSIX, so unlike Java, no wrapper script is needed.

## Building and testing

You don't need to run `make` yourself to run the tests - `rake` does it automatically (once per run, and it fails loudly with a clear message if the compiler or `make` itself isn't on PATH, or if the build fails, rather than leaving you to puzzle out the same "not recognized" error on every single test). Just run `rake` in the language directory you want, same as any other lesson suite.

To build and run a single lesson by hand, e.g. to poke at it outside the test harness:

```bash
cd compiled_lang/rust
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

## Setup

See each language's own README for what to install:

* [Java](java/README.md)
* [C#](cs/README.md)
* [Go](go/README.md)
* [Rust](rust/README.md)
* [C++](cpp/README.md)

Every one of them needs [GNU Make](https://www.gnu.org/software/make/) on PATH:

* **Windows (MSYS2)**: `pacman -S make`
* **macOS**: `xcode-select --install`, or `brew install make`
* **Linux**: usually already installed; otherwise your distro's package manager (`apt install make`, `dnf install make`, ...)

## Status

All five languages have been built and run end-to-end through `rake` (compiler/SDK installed, `make` builds it, the harness runs and passes).

`a00` ("Hello"), `h00` ("Assign by Key"), and `h10` ("Assign by List and Appending") exist per language so far - everything else shows as SKIP, same as any other lesson directory with an implementation still missing for a given category.
