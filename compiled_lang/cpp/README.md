# Compiled Language Tutorial: C++

**Summary**: C++ was created by Bjarne Stroustrup at Bell Labs, starting in 1979 as "C with Classes" and renamed C++ in 1983; it became an ISO standard with C++98 and has been revised roughly every three years since (C++11, C++14, C++17, C++20, C++23). It's a general-purpose systems language built as a strict superset of C conceptually - adding classes, templates, and RAII on top of C's low-level control - and remains the workhorse behind operating systems, game engines, browsers, and latency-sensitive backend services.

Unlike Rust or Go, C++ has no single official toolchain - the compiler (`g++`, `clang++`, or MSVC's `cl`), package manager (if you use one at all - `vcpkg` or `Conan`), and build system (Make, CMake, ...) are all separate, interchangeable tools you pick yourself. These lessons only need a compiler and GNU Make.

## 💡 Why Was It Created?

C gave systems programmers speed and hardware control but no abstraction facilities for organizing large programs. Stroustrup wanted Simula's object-oriented modeling without giving up C's performance.

1. **Zero-Cost Abstractions**: classes, templates, and RAII are designed to compile down to code as efficient as hand-written C, so higher-level abstractions ideally cost nothing at runtime.
2. **C Compatibility**: near-total backward compatibility with C gave it instant access to a huge existing codebase and toolchain ecosystem.
3. **Manual Control, By Design**: no garbage collector and no mandatory runtime - you manage memory and layout yourself, which is exactly what operating systems, game engines, and embedded targets need.
4. **Still Evolving**: the ISO standards committee keeps modernizing it - move semantics and lambdas (C++11), `std::filesystem` and structured bindings (C++17), concepts, ranges, and coroutines (C++20) - while preserving decades of backward compatibility.

## Install

* **Windows**:
  * MSYS2 (recommended, matches the rest of this project): `pacman -S mingw-w64-ucrt-x86_64-gcc`
  * or [Strawberry Perl](https://strawberryperl.com/) (bundles a MinGW-w64 `g++`)
  * or Microsoft's own compiler, `cl` - see [Building with MSVC (`cl`/NMAKE)](#building-with-msvc-clnmake) below.
* **macOS**: `xcode-select --install` (gives you `clang++` behind the `g++` name), or `brew install gcc` for a real GCC.
* **Linux**: your distro's package, e.g. `apt install g++`.

### Verify Installation

```bash
g++ --version
```

## Building and Running

### Makefile

```bash
cd compiled_lang/cpp
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

### Running Tests

You can build the binaries and run tests to verify:

```bash
rake
```

### Building with MSVC (`cl`/NMAKE)

If you have the [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022) installed (the "Desktop development with C++" or `Microsoft.VisualStudio.Workload.VCTools` workload), `Makefile.nmake` builds the same lesson with `cl` via NMAKE instead of GNU Make + `g++`. Windows also needs this same workload for C#'s Native AOT builds (see [cs/README.md](../cs/README.md#notes)), even if you never touch `cl`/NMAKE directly here.

**Windows: Chocolatey**

```powershell
choco install -y visualstudio2022buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
```

This installs just the Build Tools (compiler/linker only, no IDE) with the C++ workload pre-selected, equivalent to picking "Desktop development with C++" in the graphical installer. Swap `visualstudio2022buildtools` for `visualstudio2022community`/`-professional`/`-enterprise` if you'd rather install the full IDE.

`cl`/`nmake` aren't on `PATH` in a plain shell - you need the MSVC environment set up first. Either open a **"Developer Command Prompt for VS 2022"** / **"Developer PowerShell for VS 2022"** from the Start menu, or set it up in a regular session yourself:

```powershell
# PowerShell
Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell -VsInstallPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools" -DevCmdArguments "-arch=x64"
```

```bat
:: cmd.exe
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
```

(adjust the path if you installed a different VS edition, e.g. `Community` instead of `BuildTools`)

Then build with the `/f` flag, since `nmake` alone would otherwise look for a plain `Makefile` (the GNU one, which it can't parse):

```bat
nmake /f Makefile.nmake
bin\a00.output.exe
```

Unlike the GNU Makefile, NMAKE has no wildcard/glob function - `Makefile.nmake`'s `SOURCES`/`BINARIES` lists are maintained by hand, so add a line to each when you add a new lesson.

## Notes

Compiled with `-std=c++17 -O2 -Wall`. Each lesson is a single translation unit, built in two steps rather than g++'s usual one-shot compile+link, so there's a real object file to put in `target/`: `g++ -c src/a00.output.cpp -o target/a00.output.o`, then `g++ target/a00.output.o -o bin/a00.output` - no build system beyond the Makefile itself.

## Visual Studio Extensions

* [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) (by Microsoft) — IntelliSense, debugging, and code browsing for C/C++.
* [C/C++ Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack) — bundles the C/C++ extension above with CMake Tools and a themed icon set (CMake isn't used by these lessons, but the pack is the common starting point).
* [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb) (by vadimcn) — an LLDB-based debugger; a solid alternative to the C/C++ extension's own debugger on macOS.
* [clangd](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd) (by LLVM) — an alternative language server built on the same engine as `clang++`, if you'd rather not use Microsoft's IntelliSense.

### Visual Studio Configuration

Open your settings file in VS Code (Cmd + Shift + P -> Preferences: Open User Settings (JSON)) and add these C++-specific configurations:

```json
{
  // 1. Point IntelliSense at this project's actual compiler and standard
  "C_Cpp.default.compilerPath": "/usr/bin/g++",
  "C_Cpp.default.cppStandard": "c++17",

  // 2. Format code automatically on save (uses clang-format under the hood)
  "[cpp]": {
    "editor.defaultFormatter": "ms-vscode.cpptools",
    "editor.formatOnSave": true
  },

  // 3. Show inlay hints for parameter names
  "C_Cpp.inlayHints.parameterNames.enabled": true
}
```

### Visual Studio Debugging

To enable step-by-step debugging of a compiled lesson binary in VS Code:

1. Press Cmd + Shift + P and select Debug: Add Configuration...
2. Choose C++ (GDB/LLDB) if using the C/C++ extension, or LLDB if using CodeLLDB.
3. Use this sample `.vscode/launch.json` template:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "lldb",
      "request": "launch",
      "name": "Debug C++ Lesson",
      "program": "${workspaceFolder}/bin/a00.output",
      "args": [],
      "cwd": "${workspaceFolder}"
    }
  ]
}
```

Swap `bin/a00.output` for whichever lesson binary you want to step through (build it first with `make`).

## Further Reading

* [isocpp.org](https://isocpp.org/) — the Standard C++ Foundation, home of the ISO C++ committee's public-facing resources.
* [cppreference.com](https://en.cppreference.com/) — the de facto standard reference for the language and standard library.
