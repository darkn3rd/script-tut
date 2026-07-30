# Testing Box

© Joaquin Menchaca, 2014-2026

## Overview

Testbox is a shared test harness for testing the language lessons against a set of expected inputs and outputs specified in `expected.json`. This framework is useful for testing common language functionality and quickly learning a new language.   

The test harness (`Script.rb` for Rake, `TestBox.psm1` for psake) will run each languag's implmentation of the lession, catpure the final output, and compare it to the expected result, and then generate a a summary report. 

Each language directory just supplies a thin `Rakefile` or `psakefile.ps1` that imports the shared harness, so the comparison logic, tolerance rules (precision, unordered output, etc.), and pass/fail/skip reporting live in one place rather than being duplicated per language. Running `rake` in any lesson directory drives the Rake harness against that directory's scripts; running `Invoke-psake` (from `pwsh`, cross-platform) drives the psake harness the same way. Both print a PASS/FAIL/SKIP report with a summary tally.

## Requirements

* **Requirements**:
  * All Systems:
    * **[Ruby](https://www.ruby-lang.org)** 1.9+
      * **[Rake](https://github.com/ruby/rake)** - `gem install rake`
  * Windows Systems
    * **[MSYS2](https://www.msys2.org/)** for shell scripts `choco insatll msys2`
    * **[Psake](https://psake.dev/)** (optional) `choco install psake`
    * **[Ruby](https://www.ruby-lang.org)** `choco install ruby`
      * **[Rake](https://github.com/ruby/rake)** - bundled with Ruby 

Once these components are installed, just type `rake` in the desired script directory to run the tests. Type `rake header` to print out the environment.

Naturally, the desired scripting language must be installed for the test suite to work on that language.

### Windows 11

You can install the requirements with the following

```bash
# Install Ruby and Psake
choco install -y choco.config 
```

### macOS 26.5 "Tahoe"

```bash
# Install Dotnet, Powershell, and Ruby
brew bundle --verbose
```

Run `pwsh` shell and then run the following:

```powershell
# Install the Psake module
Install-Module -Name psake -Scope CurrentUser
# Import the Psake module
Import-Module psake
```

## Instructions

The directory structure of this repository will include these directories:

```
.
├── configbox
├── lessons
│   ├── compiled_lang
│   │   ├── cpp
│   │   ├── cs
│   │   ├── go
│   │   ├── java
│   │   └── rust
│   ├── gen_scripts
│   │   ├── awk
│   │   ├── groovy
│   │   ├── perl
│   │   ├── php
│   │   ├── python2
│   │   ├── python3
│   │   ├── ruby
│   │   └── tcl
│   ├── shell_scripts
│   │   ├── bash
│   │   ├── csh
│   │   ├── ksh
│   │   ├── posix
│   │   └── zsh
│   └── win_scripts
│       ├── batch
│       ├── powershell
│       ├── wsh.jscript
│       └── wsh.vbscript
├── scriptbox
├── supporing_docs
└── testbox
```

`lessons/compiled_lang` follows the same `Rakefile`-imports-testbox convention as everywhere else, but needs a compiler and `make` too - see [compiled_lang/README.md](../lessons/compiled_lang/README.md).

## Running Tests

These tools are executed as tasks using a build automation tool: **[Rake](https://github.com/ruby/rake)** or **[Psake](https://github.com/psake/psake)**.  Under the desired language directory, run either `rake` or `Invoke-psake -Quiet` to execute test.  

### Windows 

The table below shows what is supported.

| Directory | Rake | Psake |
|-----------|------|-------|
| `lessons/compiled_lang`            | `cmd.exe`, **PowerShell**, **MSYS2**  | — |
| `lessons/gen_scripts`              | `cmd.exe`, **PowerShell**, **MSYS2**  | `cmd.exe`, **PowerShell** |
| `lessons/shell_scripts`            | **MSYS2** or other bash shell only    | — |
| `lessons/win_scripts/batch`        | `cmd.exe`, **PowerShell**             | `cmd.exe`, **PowerShell** |
| `lessons/win_scripts/powershell`   | `cmd.exe`, **PowerShell**, **MSYS2**  | `cmd.exe`, **PowerShell** |
| `lessons/win_scripts/wsh.jscript`  | `cmd.exe`, **PowerShell**, **MSYS2**  | `cmd.exe`, **PowerShell** |
| `lessons/win_scripts/wsh.vbscript` | `cmd.exe`, **PowerShell**, **MSYS2**  | `cmd.exe`, **PowerShell** |

### macOS

On macOS, you can run `rake` using a POSIX Shell, such as `bash` or `zsh` or under PowerShell (`pwsh`).  The `Invoke-psake` command will only run under PowerShell (`pwsh`).

| Directory | Rake | Psake |
|-----------|------|-------|
| `lessons/compiled_lang`            | POSIX shell, `pwsh` | — |
| `lessons/gen_scripts`              | POSIX shell, `pwsh` | `pwsh` |
| `lessons/shell_scripts`            | POSIX shell, `pwsh` | — |
| `lessons/win_scripts/batch`        | — |  — |
| `lessons/win_scripts/powershell`   | POSIX shell, `pwsh` |  `pwsh` |
| `lessons/win_scripts/wsh.jscript`  | — | — |
| `lessons/win_scripts/wsh.vbscript` | — | — |

## Language Test Structure

### Scope

Develop a system that will verify the functionality of each script, and report the findings.

### Organization of Script Tutorial

Each set of scripts are organized in a main topic category of **A** to **M**, which is further organized in sub-category, of **0** to **9**.

This category will be followed **0** to **9** methods to do the particular category.  If the first script, **0** is missing, then the following scripts are alternative methods (workarounds) for implementing the absent feature.

*Example*:

* A00 - A0 category, 1st script
* A10 - A1 category, 1st script
* B00 - B0 category, 1st script
* B01 - B0 category, 2nd script (alternative method)
* B02 - B0 category, 3rd script (alternative method)
* C01 - C0 category, 1st alt method for absent feature
* C02 - C0 category, 2nd alt method for absent feature

### Product Requirements

The testing system will have a test harness or test runner that will run test cases.

* **Test Runner**
  * dynamically general list of scripts
  * execute variable number of scripts per category
  * generate resulting report of pass/fail
* **Test Cases**
  * test cases will organized by main category **A** to **M**.
  * test cases will run 1+ tests (negative, positive)
  * dynamically load input and output
    * input - arguments or standard input
    * output - standard error or standard output
      * exit code (optinal)

#### Test Data

The test data contains the following format:

```JavaScript
{
  plan01: [{"out": "Script says blah"}],
  plan01: [{"arg": "", "err": "Usage: blah"},
  {"arg": "3 4", "Some output here"],
  plan03: [{"in": "Name\n", "out": "Hello Name."}],
  plan04: [{"in": "Name\nquit\n", "out": "Hello Name!\nEnter your name (quit to Exit): "}]
}
```

## The Product Implementation

### Overview

The Rake task-build tool will be the *test runner* with `testbox.rake` listing the test cases organized into groups.  Any test run will print a header.

This system will perform the following features:

 * Environment detection for reporting and executing scripts
 * Dynamic generation of scripts to be tested
 * Dynamic configuration of expected inputs and results (`expecteed.json`)

### Testing

* 📀 macOS "Tahoe" 26.5
* 📀 Windows 11 Home `[WinNT 10.0.26200.8875]`
  * 📦 **[MSYS2](https://www.msys2.org/)** for `lessons/shell_scripts`
  
## Research

### Ruby Rake Tool

*[Rake](https://github.com/ruby/rake) is a software task management and build automation tool. It allows you to specify tasks and describe dependencies as well as to group tasks in a namespace.* - [Wikipedia](http://en.wikipedia.org/wiki/Rake_%28software%29)  It was originated by [Jim Weirich](http://en.wikipedia.org/wiki/Jim_Weirich).


* Articles
   * [Using the Rake Build Language](http://martinfowler.com/articles/rake.html)
   * [Rake Tutorial](http://lukaszwrobel.pl/blog/rake-tutorial)
   * Videos
   * [Basic Rake by Jim Weirich](https://www.youtube.com/watch?v=AFPWDzHWjEY)
* Source
   * [Rake Source](https://github.com/ruby/rake)


## Status

* 2014-01-05:
   * Basic framework organization.
   * Test runner (Rake) executes scripts
* 2015-01-11
   * JSON container and expected data set
   * Script class to facilitate running tests, collecting/reporting results, reporting environment.
   * TestSuite (organization, structure, reporting) completed using Rakefile
   * Adjustments to scripts, dataset, and bug fixes
   * Initial support for dynamic data in dataset
   * Discovered potential bugs in Groovy and Perl, other areas involved quirky behavior
* 2015-01-12
   * Added Initial Support for Windows (GNUWin32 + Ruby + PHP + Python)
* 2015-01-20
   * Updated TestSuite to support Windows
     * Requires GetGNUWin32 0.6.3 commands: `cut`, `grep`, `tr`, `which`
        * strange behavior and corruption with `grep | sed` or `grep | tr` patterns
        * single quotes are not supported with GNUWin32
   * Tested with **PowerShell**, **JScript**, **VBScript**, and **Batch** from *Windows Command Shell* (`cmd.exe`).
* 2015-01-23
   * Observed bug with input on Windows.  Need to debug
* 2026-07-23
   * **Rake** test framework updated to support command shell, powershell, and msys2
   * Added **psake** support for `win_scripts` and `gen_scripts`
   * All scripts in `win_scripts` and `gen_scripts` should work with either **rake** or **psake** provided the langauge is installed. 
   * All scripts in `shell_scripts` and `gen_sripts` should work in MSYS2 using rake.
   * Added tolerance logic in test harness to handle
     * **floating point precision** varies across languages
     * **booleans** when converted to strings varies across languages: `1`, `true`, or `True`.
     * **associate array** (also hash, map, object): ordering of keys where order is not guaranteed. Groovy recalls the order at  which items are inserted
* 2026-07-24
   * Added `compiled_lang` for languages needing a build step first: **Java**, **C#**, **Go**, **Rust**, **C++**. Each directory gets a `Makefile` (GNU Make) that `rake` runs automatically before testing - see [compiled_lang/README.md](../lessons/compiled_lang/README.md).
   * Test harness now supports compiled languages generically: verifies the compiler (and `make`) are on PATH before building, invokes the build artifact (not the source file) per test, and fails once with a clear message rather than a wall of confusing per-test errors if the build is broken.
   * Java has no single-file "compile to a real binary" option, so its Makefile generates a small launcher (POSIX shell script, or `.bat` on Windows) under the same naming convention instead.
   * Only `a00` exists per compiled language so far; Java, Rust, and C++ verified end-to-end through `rake`, Go and C# are unverified (no toolchain available to test with).
* 2026-07-24 (cont'd)
   * Added `h00`/`h10` (associative arrays) for **bash** and all of `compiled_lang`. Verified end-to-end for Java, Rust, C++, and (now that a real Go toolchain was found on the box) Go.
   * Added `compiled_lang/cpp/Makefile.nmake`, an NMAKE + MSVC (`cl`) alternative to the GNU Makefile, verified end-to-end with a real Build Tools install. `nmake`/`make` peacefully coexist since NMAKE needs an explicit `/f Makefile.nmake` (its own default filename search would otherwise collide with the GNU one).
   * `bin/` build output made shell-agnostic: `mkdir -p bin` (POSIX-only flag) replaced with a plain `mkdir bin` across all five Makefiles, since GNU Make falls back to `cmd.exe` as the recipe shell when `sh.exe` isn't reachable (e.g. a plain PowerShell + `vcvars64.bat` session), and `cmd.exe`'s builtin `mkdir` doesn't understand `-p`.
   * C# now verified too: after `csc` (bare, Roslyn's bundled `csc.dll`, and a global `dotnet tool` all turned out to be dead ends - see `cs/README.md`), switched to generating a minimal per-lesson `.csproj` and building it with `dotnet build`, which needs no NuGet/network access for a plain console app and produces a genuine native apphost on both Windows and real POSIX (no wrapper needed, unlike Java). `@@compiler[:cs]` changed from `"csc"` to `"dotnet"` accordingly.
* 2026-07-29
   * Moved `compiled_lang`, `gen_scripts`, `shell_scripts`, and `win_scripts` under a new `lessons/` parent directory, so the repo root separates the lesson content itself from the tooling directories (`testbox`, `scriptbox`, `configbox`) that operate on it. `testbox` did not move, so every language's `Rakefile`/`psakefile.ps1` (relative-path imports back to `testbox/`) needed one extra `../`/`..\` level; `common.mk` and the `Makefile`/`Makefile.win`/`Makefile.nmake` relationships within `compiled_lang` are untouched since that whole subtree moved together as a unit.

### Test Build Tools

In general, for a test runner, I explored these built-task tools (around 2014):

* [Cake](http://coffeescript.org/documentation/docs/cake.html) - CoffeeScript based
* [Gradle](http://www.gradle.org/) - Groovy based
* [Grunt](http://gruntjs.com/) - Node based
* [Psake](https://github.com/psake/psake) - PowerShell based
* [Rake](https://github.com/ruby/rake) - Ruby based (most ubiquitous)
* [SCons](http://scons.org/) - Python based
