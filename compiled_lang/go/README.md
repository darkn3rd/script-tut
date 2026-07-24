# Scripting Tutorial: Go

See [../README.md](../README.md) for the shared convention (naming, `make`, how `rake` drives the build).

## Install

* **Windows (MSYS2)**: `pacman -S mingw-w64-ucrt-x86_64-go`, or the [official installer](https://go.dev/dl/).
* **macOS**: `brew install go`, or the official installer.
* **Linux**: your distro's package, or the official installer.

Confirm it's on PATH:

```bash
go version
```

## Build and run by hand

```bash
cd compiled_lang/go
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

## Notes

`go.mod` declares a minimal module (`scripttut/compiled_lang/go`) so `go build <file>.go` works reliably regardless of the installed Go version's module-mode defaults - none of these lessons have external dependencies, so nothing else should be needed there. Each lesson is `package main` with a `main()` function; the Makefile builds each source file independently (`go build -o a00.output a00.output.go`). Verified working end-to-end with go1.26.5.
