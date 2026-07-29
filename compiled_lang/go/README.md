# Compiled Language Tutorial: Go

**Summary**: Go was created at Google in 2007 by Robert Griesemer, Rob Pike, and Ken Thompson, publicly announced in November 2009, and reached its stable Go 1.0 release in March 2012. It's a statically-typed, garbage-collected, compiled language designed for simplicity, fast builds, and concurrency as a first-class citizen. It has become the default language for cloud infrastructure - Docker, Kubernetes, Terraform, and most of the modern container/orchestration ecosystem are written in Go.

Go has the following tools, mostly rolled into a single binary:

* **`go`** is the compiler, build tool, test runner, formatter (`gofmt`), and module/package manager all in one - there's no separate `cargo`-equivalent name, it's all just `go build`/`go test`/`go get`
* **Go modules** (`go.mod`/`go.sum`) are the built-in dependency/package management system, no external tool needed
* there's no official `rustup`-style version manager - most people either install one version system-wide via Homebrew/apt/the official installer, or use a third-party tool (e.g. `g`, `gvm`) when they need several side by side

## 💡 Why Was It Created?

Google engineers were frustrated with slow build times across huge C++ codebases, verbose class hierarchies, and languages like Python that traded away static typing and raw speed. They wanted something that compiled fast, stayed simple, and made concurrent, networked services easy to write correctly.

1. **Build Speed at Scale**: C++ compile times across Google's codebase were untenable; Go's simple grammar and dependency model made builds dramatically faster.
2. **Deliberate Simplicity**: a small language (25 keywords), no classes or inheritance - just structs, interfaces, and composition - and no generics at all until Go 1.18 (2022).
3. **Concurrency as a First-Class Feature**: goroutines and channels make concurrent programming a cheap, built-in language construct instead of a bolted-on threading library.
4. **Batteries-Included Tooling**: `gofmt`, `go vet`, `go test`, and modules ship in the box - there's no ecosystem-wide debate over which build system or formatter to use.

## Install

You can use the [official installer](https://go.dev/dl/) the installers, or usage one of these package managers below.

### macOS: Homebrew

```bash
brew install go
```

### Windows: Chocolatey

```pwsh
choco install -y go
```

### MSYS (Windows)

There are native packages for go lang:

```bash
#  install latest go lang
pacman -S mingw-w64-ucrt-x86_64-go

# configure shell startup
cat >> ~/.bashrc <<'EOF'

# MSYS2 UCRT64 Go
export GOROOT=/ucrt64/lib/go
export PATH="$GOROOT/bin:$HOME/go/bin:$PATH"
EOF

# update current environment
source ~/.bashrc

# install go imports
go install golang.org/x/tools/cmd/goimports@latest
```

### Ubuntu 22.04 Jammy Jellyfish

```bash
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go

# shell profile example; add to ~/.bashrc, ~/.zshrc
export GOPATH=$(go env GOPATH)
export PATH=$GOPATH/bin:$PATH

# install go imports
go install golang.org/x/tools/cmd/goimports@latest
```

### Verify Installation

```bash
go version
```

## Building and Running

### Makefile

```bash
cd compiled_lang/go
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

### Running Tests

You can build the binaries and run tests to verify:

```bash
rake
```

## Notes

`go.mod` declares a minimal module (`scripttut/compiled_lang/go`) so `go build <file>.go` works reliably regardless of the installed Go version's module-mode defaults - none of these lessons have external dependencies, so nothing else should be needed there. Each lesson is `package main` with a `main()` function; the Makefile builds each source file independently into `target/`, then copies the result into `bin/` (`go build -o target/a00.output src/a00.output.go`) - `go build` compiles straight to a final binary in one step, so this is purely to keep the same `target/`-then-`bin/` shape every language here follows. `go.mod` itself stays at the language directory root rather than moving into `src/` - Go resolves the nearest `go.mod` by walking up from the source file's directory, so it's found there regardless. Verified working end-to-end with go1.26.5.

`go.mod` currently declares `go 1.23`, needed for the `iter` package (range-over-func iterators) and range-over-int, both used by a couple of the loop lessons - bump it further if a future lesson needs something newer.

## Visual Studio Extensions

* [Go](https://marketplace.visualstudio.com/items?itemName=golang.go) (by the Go Team at Google) — the one extension you actually need: IntelliSense (via `gopls`), formatting, linting, test discovery, and Delve-based debugging.

The extension prompts to install its own supporting tools (`gopls`, `dlv`, `staticcheck`, ...) into `$(go env GOPATH)/bin` on first use - accept that prompt rather than installing them by hand.

### Visual Studio Configuration

Open your settings file in VS Code (Cmd + Shift + P -> Preferences: Open User Settings (JSON)) and add these Go-specific configurations:

```json
{
  // 1. Format (and organize imports) automatically on save
  "[go]": {
    "editor.defaultFormatter": "golang.go",
    "editor.formatOnSave": true
  },
  // 2. Run go vet (or staticcheck) automatically on save
  "go.lintOnSave": "package",
  "go.vetOnSave": "package",

  // 3. gofumpt formatting, plus inlay hints for parameter names and
  //    composite literal fields
  "gopls": {
    "formatting.gofumpt": true,
    "ui.inlayhint.hints": {
      "parameterNames": true,
      "compositeLiteralFields": true
    }
  }
}
```

### Visual Studio Debugging

To enable step-by-step debugging of a compiled lesson binary in VS Code:

1. Press Cmd + Shift + P and select Debug: Add Configuration... and choose Go.
2. Use this sample `.vscode/launch.json` template - `"mode": "exec"` debugs an already-built binary directly, rather than rebuilding from source:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Go Lesson",
      "type": "go",
      "request": "launch",
      "mode": "exec",
      "program": "${workspaceFolder}/bin/a00.output"
    }
  ]
}
```

Swap `bin/a00.output` for whichever lesson binary you want to step through (build it first with `make`).

## Testing

* 📀 *__macOS 26.5 (Tahoe)__*
  * ⚙️ go version go1.26.4
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)


## Further Reading

* [go.dev/doc](https://go.dev/doc/) — official documentation, including the language spec and Effective Go.
* [go.dev/blog](https://go.dev/blog/) — the official Go blog, including the original announcement history.
