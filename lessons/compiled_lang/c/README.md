# Compiled Language Tutorial: C

**Summary**: C was created by Dennis Ritchie at Bell Labs between 1969 and 1973, originally to rewrite Unix itself in a portable systems language instead of assembly. Standardized as ANSI C (C89) in 1989 and revised several times since (C99, C11, C17, C23), it remains the closest thing to a lingua franca for systems programming - kernels, embedded firmware, language runtimes, and most other compiled languages' own C-compatible FFI boundary are all built on it.

Unlike Go or Rust, C has no official package manager or build system bundled with the language itself - these lessons only need a compiler and GNU Make. [Package Management (Conan)](#package-management-conan) below shows one way to add a real third-party library on top of that.

## 💡 Why Was It Created?

Unix was originally written in PDP-7 assembly - unportable, and painful to maintain. Ritchie (building on Ken Thompson's earlier B language) wanted something with just enough abstraction to write an operating system in, without giving up direct hardware control.

1. **Portability**: a C compiler could be retargeted to new hardware far more easily than hand-written assembly, which is exactly how Unix itself spread beyond the PDP-11.
2. **Minimal Runtime**: no garbage collector, no exceptions, no hidden allocations - what you write is close to what the machine actually does.
3. **Direct Memory Access**: pointers and manual memory management give the low-level control an operating system kernel needs.
4. **Small, Stable Core**: the language itself has stayed deliberately small across every revision - most of its power comes from the standard library and whatever else you choose to link against.

## Install

* **Windows**:
  * MSYS2 (recommended, matches the rest of this project): `pacman -S mingw-w64-ucrt-x86_64-gcc`
  * or [Strawberry Perl](https://strawberryperl.com/) (bundles a MinGW-w64 `gcc`)
* **macOS**: `xcode-select --install` (gives you `clang` behind the `gcc` name)
* **Linux**: your distro's package, e.g. `apt install gcc`.

### Verify Installation

```bash
gcc --version
```

## Building and Running

### Makefile

```bash
cd lessons/compiled_lang/c
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

### Running Tests

```bash
rake
```

## Multi-Architecture Builds

Unlike the other four languages here, C's own performance-tuning flags are architecture-specific (see the Makefile's `CFLAGS_$(ARCH)`), so a stale object file compiled for one CPU architecture must never get silently relinked into a binary for another just because its timestamp looks current. `target/` is namespaced per `$(uname -s)_$(uname -m)` for exactly this reason - `bin/` itself stays flat (a single `bin/a00.output` regardless of architecture), matching every sibling language and what the test harness expects.

Rebuilding for a different architecture on the same checkout (e.g. testing both an Intel and an Apple Silicon VM against the same working copy) just works - no `make clean` needed between them:

```bash
make            # uses uname -m automatically
make ARCH=arm64 # force a specific architecture instead
```

## Package Management (Conan)

C has no bundled package manager, but [Conan](https://conan.io/) is a common third-party choice. `conanfile.txt` here pulls in [cJSON](https://conan.io/center/recipes/cjson), and `src/extra.conan_cjson.c` is a bonus variant of `h00.associative.c` (the "Associative Arrays" lesson) that builds a JSON object with it instead of a hand-rolled key/value array - same output, different approach:

```bash
pip install conan          # one-time, if you don't already have it
conan profile detect       # one-time, autodetects your compiler/arch
conan install . --output-folder=. --build=missing
make conan
./bin/extra.conan_cjson
```

`extra.conan_cjson.c` is deliberately excluded from `make`'s default `all` target and from `rake`'s own per-lesson test discovery (its filename doesn't match the `a00`-`o20` numbering testbox globs for) - a plain `make`/`rake` here always succeeds with no Conan involved at all. `conan install` generates `conandeps.mk`, which the Makefile pulls in automatically (via `-include`) only for the explicit `make conan` target. Everything above works the same on any architecture Conan has a `cjson` binary or build recipe for.

## Notes

Compiled with `-std=c17 -O2 -Wall -Wextra`. Each lesson is a single translation unit, built in two steps rather than one-shot compile+link, so there's a real object file to put in `target/`.

C has no built-in dynamic string, array, or hash-map type the way C++/Go/Rust do - the associative-array lessons (`h00`/`h10`) use a small fixed-size array of key/value structs, searched linearly, as the idiomatic stand-in; `m20.function.c` ("returning an array") uses an out-parameter, since C can't return an array by value.

## Testing

* 📀 *__macOS (Apple Silicon and Intel VMs)__*
  * ⚙️ Apple clang (behind the `gcc` name via Xcode Command Line Tools)

## Further Reading

* [cppreference.com/w/c](https://en.cppreference.com/w/c) — a de facto standard reference for the language and standard library (despite the domain name).
* [Conan Center](https://conan.io/center) — the public package index used by `conanfile.txt` above.
