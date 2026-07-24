# Scripting Tutorial: Rust

See [../README.md](../README.md) for the shared convention (naming, `make`, how `rake` drives the build).

## Install

* **Windows / macOS / Linux**: [rustup](https://rustup.rs/) - the standard installer, gives you `rustc` and `cargo`.
  * Windows (MSYS2): `pacman -S mingw-w64-ucrt-x86_64-rust`, or use rustup.
  * macOS: `brew install rust`, or use rustup.
  * Linux: your distro's package, or rustup.

Confirm it's on PATH:

```bash
rustc --version
```

## Build and run by hand

```bash
cd compiled_lang/rust
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

## Notes

Each lesson is compiled standalone with `rustc` directly (`rustc -O -o a00.output a00.output.rs`) - no Cargo project/`Cargo.toml` needed, since these are single-file lessons with no external crates. `rustc` derives a default crate name from the output file name and rejects the dots in these lesson names (`a00.output` isn't a valid crate name) - the Makefile works around this with `--crate-name`, substituting underscores for dots; you won't need to think about this unless you're compiling a lesson by hand outside the Makefile.
