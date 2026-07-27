# Compiled Languages

© Joaquin Menchaca, 2026

## Overview

The `compiled_lang` holds implementations of the same lessons as `gen_scripts`/`shell_scripts`/`win_scripts`, but for languages that need a build step first: Java, C#, Go, Rust, and C++. Each lesson is still one source file per test (`a00.output.java`, `a00.output.rs`, ...), but before the test harness can run it, a `Makefile` in that directory has to turn it into something runnable.

## Directory Structure

Every language directory here follows the same three-way split:

* `src/` - every lesson's source file (`a00.output.rs`, `f00.loop.rs`, ...) - the only thing you'd actually edit.
* `target/` - everything the build generates *except* the final runnable thing: object files, a generated project file (C#'s throwaway `.csproj`), compiled classes (Java's `.class`), debug symbols, and so on. Nothing here is meant to be run directly or committed.
* `bin/` - the final, runnable artifact for each lesson, named after its source file **minus the language extension** (`a00.output.rs` -> `bin/a00.output` on macOS/Linux, `bin/a00.output.exe` on Windows) - this is what the test harness (and you, by hand) actually invokes. For four of the five languages this is a single self-contained executable; Java's is a tiny launcher script (see below), since Java has no such option at all.

Plus, at the language directory root (not moved into any of the above):

* `Makefile` - builds `src/*` into `target/`, then promotes the final artifact into `bin/`. `make clean` empties both `target/` and `bin/` back out. Both are gitignored (only their `.gitkeep` is tracked, so the directories themselves exist on a fresh checkout).
* `common.mk` (one level up, shared by all five) - figures out whether the build is targeting Windows or real POSIX, since that decides both the output extension and, for some languages, how the runnable artifact is actually shaped (see below).
* `Rakefile` - a one-liner that imports the shared [testbox](../testbox/README.md) harness, exactly like every other lesson directory.
* `dirtest/` - the fixture directory the Collection Loop (F0) lesson reads. This one's deliberately *not* under `src/` or `bin/`: the harness never changes directory before running a lesson (`make`, the promoted `bin/` binaries, and this fixture all need to stay reachable from the language directory root - see `testbox/Script.rb`'s `@@source_subdir`), so a lesson's own bare `"dirtest"` reference already resolves correctly right where it's always been.

Java and C# each need something extra beyond a plain compile-and-promote, for different reasons:

* **Java** - `javac` output is named after the *class* declared inside the file, not the source file, and there's no single-file "compile to a binary" option. Each lesson's class must **not** be `public` (a `public` class's file name is required to match the class name exactly, which would conflict with this project's dotted lesson-file naming) - see `java/src/a00.output.java` for the pattern. The Makefile compiles the `.class` file into `target/`, then generates a launcher in `bin/` (a POSIX shell script, or a `.bat` wrapper on Windows) that runs `java -cp <path-to-target> ClassName`.

* **C#** - there's no simple, version-independent way to drive `csc` directly for a single file (see `cs/README.md`), so its Makefile generates a minimal, throwaway `.csproj` per lesson into `target/` and publishes it with `dotnet publish` and Native AOT (ahead-of-time compilation straight to native machine code) - a plain console app needs no NuGet/network access to do this. Unlike a plain `dotnet build` apphost (a small stub that needs a same-named `.dll` sitting next to it to actually run), AOT output is a genuinely standalone native executable, same as the other four languages - the tradeoff is that it also needs a native linker (clang/gcc, or MSVC's Build Tools on Windows) on top of the SDK.

## Windows 11 Smart App Control (SAC)

The Smart App Control (SAC) will prevent your compiled application binaries from running.  You can disable SAC with these commands:

* Using **Command Shell** (`cmd.exe`)
  ```batch
  :: Add a registry key or modify an existing one
  reg add ^
    "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" ^
    /v VerifiedAndReputablePolicyState ^
    /t REG_DWORD ^
    /d 0 ^
    /f

  :: Refresh the active system Code Integrity policies immediately
  CiTool.exe -r
  ```
* Using **PowerShell**
  ```powershell
  # Set or modify a property value inside the registry
  Set-ItemProperty `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy" `
    -Name "VerifiedAndReputablePolicyState" `
    -Value 0

  # Refresh the active system Code Integrity policies immediately
  CiTool.exe -r
  ```
* MSYS2
  ```bash
  # Define path conversion exclusion so MSYS2 does not alter the flags
  export MSYS2_ARG_CONV_EXCL="*"
  
  # Call the native Windows reg tool to modify the policy state to 0 (Off)
  reg.exe add \
    "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" \
    /v VerifiedAndReputablePolicyState \
    /t REG_DWORD \
    /d 0 \
    /f

  # Force Windows Code Integrity to reload policies immediately
  CiTool.exe -r
  ```

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

Implemented so far, per language: `a0`-`a2` (Output), `b0`/`b1`/`b3` (Variables - `b2`, String Formatting, still missing), `c0`-`c3` (Arithmetic), `d0` (Line Input - `d1`, Character Input, still missing), `e0`-`e6` (Branching), `f0`-`f4` (Looping - several implementations each, showing off each language's own loop constructs; Go has one fewer variant of `f3` and `f4` than the other four languages), `g0`-`g2` (Arrays), `h0`/`h1` (Associative Arrays), `i0`-`i2` (Subroutines), `j0`-`j2` (Arguments), `k0`/`k1` (Parameters), `l0` (Exit), `m0`-`m2` (Functions). Still missing across all five languages: `n0`-`n2` (Environment Variables) and `o0`-`o2` (Command-Line Flags). Everything else shows as SKIP, same as any other lesson directory with an implementation still missing for a given category.
