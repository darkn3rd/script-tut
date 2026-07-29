# Scripting Tutorial: Python 3

Version 1.0

© Joaquin Menchaca, 2014-2026

This is a Python 3 port of the [Python 2 tutorial](../python2/), updated to
current, supported Python syntax (`print()` as a function, `input()`,
f-strings-friendly idioms, etc.).

## Getting Python

On Windows 11, you can get Python from [Python Download](https://www.python.org/downloads/) or install it using a package manager like Chocolatey.

### macOS: Homebrew

**[Homebrew](https://brew.sh/)** is a command-line package manager for **macOS** that simplifies software installation by letting you download, update, and manage applications and tools using quick, automated commands.

```bash
# Install Python3
brew install python
```

### Ubuntu 22.04: pyenv

You must install and setup `pyenv`, see [gen_scripts/README.md](../README.md#pyenv-python-version-management)

```bash
# update python listings
pyenv update
# install Python3
pyenv install 3.14.6
pyenv install 2.7.18 # optional
# set global python
# python=3.10.4, python2=2.7.18, python=3.10.4
pyenv global 3.10.4 2.7.18
```  

### Windows: Chocolatey

**[Chocolatey](https://chocolatey.org)** is a command-line package manager for Windows, built on top of the [NuGet](https://www.nuget.org/) infrastructure, that lets you install, update, and manage software using simple, automated commands instead of clicking through setup wizards.

```powershell
# Install Python3
choco install -y python3

# python3 should point to Python 3
Copy-Item "C:\Python314\python.exe" "C:\Python314\python3.exe"
Copy-Item "C:\Python314\pythonw.exe" "C:\Python314\python3w.exe"

# If both Python2 and Python3 are installed, make sure `python` default is Python3
# Fix Path so that `python.exe` will always get Python3 (assuming Python3 is installed)
$sysPath = [Environment]::GetEnvironmentVariable("PATH", "Machine") -split ';' `
  | Where-Object { $_ -ne '' }
$python2Entries = $sysPath | Where-Object { $_ -like '*Python27*' }
$otherEntries   = $sysPath | Where-Object { $_ -notlike '*Python27*' }
$newPath = ($otherEntries + $python2Entries) -join ';'
[Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
```

### Windows: UCRT64 (MSYS2)

**[MSYS2](https://www.msys2.org/)** is a software building and distribution platform for Windows that provides a Unix-like environment (including a Bash shell and the [pacman package manager](https://www.msys2.org/docs/package-management/) from Arch Linux). It allows you to compile, install, and run native Windows software using tools like GCC, MinGW-w64, and CMake. 

**UCRT64** is one of the specific environments (or subsystems) available within **[MSYS2](https://www.msys2.org/)** used to compile native 64-bit Windows software. It targets Microsoft's modern Universal C Runtime (UCRT), which comes pre-installed by default on all modern versions of Windows 10 and 11.

If you have **[Chocolatey](https://chocolatey.org)** setup, you can install MSYS2 with `choco install msys2`.

```bash
# Update Packages
pacman -Syu
# UCRT64 Environment (Recommended)
pacman -S mingw-w64-ucrt-x86_64-python
```

## Testing
* 📀 *__macOS 26.5 (Tahoe)__*
  * 📦 Python 3.14.6
* 📀 Pop!_OS 22.04 (Ubuntu 22.04)
  * 📦 Python 3.10.12 (pyenv)
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * 🐚 PowerShell 5.1.26100.8875
    * 📦 Python 3.14.3
  * 🐚 Command Shell (C:\Windows\System32\cmd.exe)
    * 📦 Python 3.14.3
  * 🐚 MSYS2 UCRT64 20260611.0.0 bash
    * 📦 Python 3.14.6
  * 🐚 Cygwin 3.6.10-1
    * 📦 Python 3.12.12
    
## Notes

This covers notes regarding each section.

1. Output
   * output text to standard out
   * output text to standard error
     * demonstrate `print(..., file=sys.stderr)`
     * demonstrate: `sys.stderr.write`
   * output multi-line text using `"""`
2. Variables
   * output variables using string concatenation
   * output variables using string interpolation
     * demonstrate using `%` operator
     * demonstrate using `format()` method
   * output variables using formatting
     * demonstrate using f-strings (formatted string literals) with
       explicit format specifiers, distinct from the `%` operator and
       `format()` method above
   * store multi-line text in a variable using a triple-quoted string,
     then print it
3. Arithmetic
   * show basic integer arithmetic
   * show basic boolean evaluation
   * show basic floating math with exponetial
   * show basic math function like cosine
4. Input
   * input a string
   * input a single character
5. Branch
   * test a string using `if`
   * test a string using ternary construction
   * test a number range
   * test a number for menu selection
   * multi-way test on a number for menu selection
     * **NOTE** Uses the `match`/`case` statement (Python 3.10+); prior to
       3.10 Python had no multiway branch mechanism
   * multi-way test on single character with pattern matching
     * **NOTE** Uses `match`/`case` (Python 3.10+) with guard clauses
       (`case c if re.match(...)`) to emulate pattern matching, since
       `match`/`case` patterns themselves don't support regex/glob
   * test on single character with pattern matching
     * **NOTE** Utilized `python re.match(patter, string)` to simulate `=~`
     * **ALTERNATIVE** Using built-in Pythion `isdigit()`, `isupper()`, and `islower()`
6. Looping
   * collection loop with `for...in`
   * count style loop
     * demonstrate using `while`
     * demonstrate using collection loop and `range(times)`
     * demonstrate using collection loop and `reversed(range(times))`
     * demonstrate using collection loop and `range(start,downto,decrement)`
   * conditional loop
   * spin loop
   * spin loop with ability skip invalid input
7. Arrays
   * Array Initialization
      * initialize array by index
      * array length
      * enumerate all elements
   * Array Enumeration
      * declare and initialize array
      * enumerate array by collection loop
8. Associative Arrays
   * Associative Array Initialization
      * initialize associative array by key
      * enumerate all keys
      * enumerate all values
        * **NOTE** `dict.keys()`/`dict.values()` return view objects in
          Python 3, not lists; wrapped in `list()` for enumeration parity
   * Associative Array Enumeration
      * declare and initialize associative array
      * merge two associative arrays
      * enumerate associative array by key
9. Subroutines
   * demonstrate declaring and calling subroutine
   * demonstrate subroutine referencing global variables
   * demonstrate subroutine explicitly using local variables
10. Arguments
    * demonstrate processing 2 arguments
      * **NOTES:** Python includes scriptname as first argument in `sys.argv`
    * demonstrate printing all arguments
      * use collection loop with list slice
      * use collection loop with `range()`
      * use count style loop using `while`
    * demonstrate printing arguments in reverse order
      * use count style loop using `while`
      * use collection loop with `range()`
      * use collection loop with list slice
11. Parameters
    * demonstrate passing a single parameter
    * demonstrate passing unlimited parameters
    * demonstrate swapping two variables passed in as parameters
      * **NOTE** Python does not have support for pass-by-reference, so we must package them up into a memory referenced datatype, so that the subroutine can swap them.
12. Exiting
    * demonstrate exiting with error code to communicate status
13. Functions
    * demonstrate function that returns an int
    * demonstrate function that returns a string
    * demonstrate function that returns an array

## Porting Notes (Python 2 → 3)

Changes applied throughout relative to the [Python 2 scripts](../python2/):

* `print` statement → `print()` function
* `raw_input()` → `input()`
* `sys.stdin`/`sys.stdout` are text streams by default (no behavior change needed)
* `dict.keys()` / `dict.values()` return views, wrapped in `list()` where the
  original relied on list output
* Regex patterns using backslash escapes (e.g. `\s`, `\t`) written as raw
  strings (`r"..."`) to avoid deprecation warnings
* Removed an unused `import string` in `m10.function.py` (the parameter name
  `string` shadowed it even in the Python 2 original)
