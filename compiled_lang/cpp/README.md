# Scripting Tutorial: C++

See [../README.md](../README.md) for the shared convention (naming, `make`, how `rake` drives the build).

## Install

* **Windows**:
  * MSYS2 (recommended, matches the rest of this project): `pacman -S mingw-w64-ucrt-x86_64-gcc`
  * or [Strawberry Perl](https://strawberryperl.com/) (bundles a MinGW-w64 `g++`)
  * or Microsoft's own compiler, `cl` - see [Building with MSVC (`cl`/NMAKE)](#building-with-msvc-clnmake) below.
* **macOS**: `xcode-select --install` (gives you `clang++` behind the `g++` name), or `brew install gcc` for a real GCC.
* **Linux**: your distro's package, e.g. `apt install g++`.

Confirm it's on PATH:

```bash
g++ --version
```

## Build and run by hand

```bash
cd compiled_lang/cpp
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

## Notes

Compiled with `-std=c++17 -O2 -Wall`. Each lesson is a single translation unit (`g++ a00.output.cpp -o a00.output`) - no build system beyond the Makefile itself.

## Building with MSVC (`cl`/NMAKE)

If you have the [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022) installed (the "Desktop development with C++" or `Microsoft.VisualStudio.Workload.VCTools` workload), `Makefile.nmake` builds the same lesson with `cl` via NMAKE instead of GNU Make + `g++`.

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
