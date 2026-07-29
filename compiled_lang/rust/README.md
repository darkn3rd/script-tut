# Compiled Language Tutorial: Rust

**Summary**: Rust is a high-performance systems programming language created by Graydon Hoare at Mozilla in 2006 and officially launched as version 1.0 in 2015. It was designed to replace C and C++ by offering bare-metal speed while eliminating critical memory bugs and crash-causing race conditions. Today, it achieves memory safety at compile time without needing a slow garbage collector, making it a favorite for building operating systems, browser engines, and high-performance services.

Rust has the follwoing toools:

* **`rustc`** is the compiler and linker for the Rust language
* **`cargo`** is the package manager for installing Rust modules
* **`rustup`** is the official toolchain installer and version manager for Rust—think of it like `nvm` for Node.js, `pyenv` for Python, or `rbenv` for Ruby.

## 💡 Why Was It Created?

Historically, systems programming languages like C and C++ gave developers raw speed and control over memory, but at a huge cost: frequent bugs, crashes, and severe security vulnerabilities (like buffer overflows and dangling pointers). On the flip side, languages that were memory-safe (like Java or Python) relied on a Garbage Collector, which slowed performance.

Rust was built to bridge this gap:

1. **Memory Safety Without Garbage Collection**: Its signature feature—the ownership and borrowing system—catches memory bugs at compile-time without needing a background runtime cleanup process.  
2. **Safe Concurrency**: Prevents multi-threading "data races" (where two threads try to modify the same piece of memory at once) at compile time.  
3. **C-Level Performance**: Delivers bare-metal speed and control, making it ideal for operating systems, game engines, WebAssembly, and high-performance backends.

## Install

### General: Rustup Installer

There's a general installer script for rust that you can use. 

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### macOS: Homebrew

**[Homebrew](https://brew.sh/)** has a formula for installing **[Rust](https://rust-lang.org/)** from source. 

```bash
brew install rust
```

If you would like to install **rustup**, you can run the following

```bash
# Install rustup via Homebrew
brew install rustup

# Add Homebrew's rustup binary location to PATH for current session and shell profiles
export PATH=$(brew --prefix rustup)/bin:$PATH
echo "export PATH=$(brew --prefix rustup)/bin:\$PATH" >> ~/.zshrc
echo "export PATH=$(brew --prefix rustup)/bin:\$PATH" >> ~/.bashrc

# Point rustup to use Homebrew's installed Rust compiler instead of downloading its own
rustup toolchain link system "$(brew --prefix rust)"
```

### Windows: Chocolatey

**[Chocolatey](https://chocolatey.org/)** has a formula for installing **[Rust](https://rust-lang.org/)**: 

```powershell
choco install -y rust
```

### MSYS2 (Windows 11)

You can install **Rust** binaries with the following:

```bash
pacman -S mingw-w64-ucrt-x86_64-rust
cat >> ~/.bashrc <<'EOF'

# Rust Cargo tools
export PATH="$HOME/.cargo/bin:$PATH"
EOF

source ~/.bashrc
```

You can install the **rustup** version manager with:

```bash
pacman -S mingw-w64-ucrt-x86_64-rustup
```

### Cygwin (Windows 11)

```bash
apt-cyg install rust
```

### Ubuntu 22.04 Jammy Jellyfish: Rustup

```bash
sudo apt install -y \
  curl \
  build-essential \
  gcc \
  make

# Install Using Rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

### Verify Installation

```bash
rustc --version
cargo --version
```

## Building and Running

### Makefile

```bash
cd compiled_lang/rust
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

### Running Tests

You can build the binaries and run tests to verify

```bash
rake
```

## Notes

Each lesson is compiled standalone with `rustc` directly (`rustc -O -o target/a00.output src/a00.output.rs`) - no Cargo project/`Cargo.toml` needed, since these are single-file lessons with no external crates. `rustc` derives a default crate name from the output file name and rejects the dots in these lesson names (`a00.output` isn't a valid crate name) - the Makefile works around this with `--crate-name`, substituting underscores for dots; you won't need to think about this unless you're compiling a lesson by hand outside the Makefile. `rustc` compiles straight to a final binary in one step (there's no separate object file the way g++ produces one), so the Makefile just builds directly into `target/` and copies the result into `bin/`, purely to keep the same `target/`-then-`bin/` shape every language here follows.

## Visual Studio Extensions

* [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer) (by rust-lang) — Crucial. This is the official Language Server Protocol (LSP) for Rust. It provides intelligent auto-completion, real-time syntax checking, inline type hints, code navigation, and refactoring support.
* [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb) (by vadimcn) — The best debugger for Rust on macOS. It integrates directly with LLDB to give you interactive breakpoint debugging, variable inspection, and stack traces.
* [Even Better TOML](https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml) — Adds syntax highlighting, validation, and auto-completion for Cargo.toml files.
* [Crates](https://marketplace.visualstudio.com/items?itemName=serayuzgur.crates) — Displays the latest available crate versions directly inside your Cargo.toml so you know when dependencies can be updated.

### Visual Studio Configuration

Open your settings file in VS Code (Cmd + Shift + P -> Preferences: Open User Settings (JSON)) and add these Rust-specific configurations:

```json
{
  // 1. Check code on save using 'cargo check' (or 'cargo clippy' for extra linting)
  "rust-analyzer.checkOnSave.command": "clippy",

  // 2. Format code automatically on save using rustfmt
  "[rust]": {
    "editor.defaultFormatter": "rust-lang.rust-analyzer",
    "editor.formatOnSave": true
  },

  // 3. Configure inline inlay hints for type inference & parameter names
  "rust-analyzer.inlayHints.typeHints.enable": true,
  "rust-analyzer.inlayHints.parameterHints.enable": true,
  "rust-analyzer.inlayHints.chainingHints.enable": true,

  // 4. Auto-import missing items when accepting completions
  "rust-analyzer.completion.autoimport.enable": true,

  // 5. Ensure cargo uses all CPU cores for builds
  "rust-analyzer.cargo.buildScripts.enable": true
}
```

**Pro-Tip on Clippy**: Setting rust-analyzer.checkOnSave.command to "clippy" enables Rust's built-in linter to highlight idiomatic code improvements in real time as you write code!

### Visual Studio Debugging

To enable F5 step-by-step debugging in VS Code on macOS:
1. Press Cmd + Shift + P and select Debug: Add Configuration...
2. Choose LLDB.
3. Use this sample .vscode/launch.json template:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "lldb",
      "request": "launch",
      "name": "Debug Rust Binary",
      "cargo": {
        "args": ["build", "--bin=my_project", "--package=my_project"],
        "filter": {
          "name": "my_project",
          "kind": "bin"
        }
      },
      "args": [],
      "cwd": "${workspaceFolder}"
    }
  ]
}
```

## Testing

* 📀 *__macOS 26.5 (Tahoe)__*
  * ⚙️ rustc 1.97.1
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
* 📀 Pop!_OS 22.04 (Ubuntu 22.04)
  * ⚙️ rustc 1.97.1 (8bab26f4f 2026-07-14)

## Further Reading

* [Rust 101 — Everything you need to know about Rust](https://medium.com/codex/rust-101-everything-you-need-to-know-about-rust-f3dd0ae99f4c) by Nishant Aanjaney Jalan on Feb 25, 2023

* Off Topic
  * [One Fetch](https://github.com/o2sh/onefetch) [github]