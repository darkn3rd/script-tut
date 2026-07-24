# Testing Box

© Joaquin Menchaca, 2014-2026

## Overview

Testbox is a shared test harness for testing the language lessons against a set of expected inputs and outputs specified in `expected.json`. This framework is useful for testing common language functionality and quickly learning a new language.   

The test harness (`Script.rb` for Rake, `TestBox.psm1` for psake) will run each languag's implmentation of the lession, catpure the final output, and compare it to the expected result, and then generate a a summary report. 

Each language directory just supplies a thin `Rakefile` or `psakefile.ps1` that imports the shared harness, so the comparison logic, tolerance rules (precision, unordered output, etc.), and pass/fail/skip reporting live in one place rather than being duplicated per language. Running `rake` or `.\psake.cmd` in any lesson directory drives this harness against that directory's scripts and prints a PASS/FAIL/SKIP report with a summary tally.

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

## Instructions

The directory structure of this repository will include these directories:

```
.
├── configbox
├── gen_scripts
│   ├── awk
│   ├── groovy
│   ├── perl
│   ├── php
│   ├── python2
│   ├── python3
│   ├── ruby
│   └── tcl
├── scriptbox
├── shell_scripts
│   ├── bash
│   ├── csh
│   ├── ksh
│   └── posix
├── supporing_docs
├── testbox
└── win_scripts
    ├── batch
    ├── powershell
    ├── wsh.jscript
    └── wsh.vbscript
```

## Running Tests

These tools are executed as tasks using a build automation tool: **[Rake](https://github.com/ruby/rake)** or **[Psake](https://github.com/psake/psake)**.  Under the desired language directory, run either `rake` or `.\psake` to execute test.  The table below shows what is supported. 


| Directory | Rake | Psake |
|---|---|---|
| `gen_scripts` | `cmd.exe`, **PowerShell**, **MSYS2** | `cmd.exe`, **PowerShell** |
| `shell_scripts` | **MSYS2** or other bash shell only | — |
| `win_scripts` | `cmd.exe`, **PowerShell** | `cmd.exe`, **PowerShell** |



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

### Technical Requirements



### Testing

* 📀 macOS "Tahoe" 26.5
* 📀 Windows 11 Home `[WinNT 10.0.26200.8875]`
  * 📦 **[MSYS2](https://www.msys2.org/)** for `shell_scripts`
  
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

### Test Build Tools

In general, for a test runner, I explored these built-task tools (around 2014):

* [Cake](http://coffeescript.org/documentation/docs/cake.html) - CoffeeScript based
* [Gradle](http://www.gradle.org/) - Groovy based
* [Grunt](http://gruntjs.com/) - Node based
* [Psake](https://github.com/psake/psake) - PowerShell based
* [Rake](https://github.com/ruby/rake) - Ruby based (most ubiquitous)
* [SCons](http://scons.org/) - Python based
