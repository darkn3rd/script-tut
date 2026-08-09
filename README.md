# Scripting Tutorial

© Joaquin Menchaca, 2014-2026

## Overview 

This repository contains a comprehensive suite of automation scripts, tools, and educational resources, spanning foundational language lessons to production-grade deployment workflows. It serves as a practical showcase of CI/CD orchestration, build automation, and infrastructure-as-code principles.

### 🛠️ Key Capabilities

* **Build & Test Frameworks:** Advanced build pipelines orchestrated via [`Rake`](https://github.com/ruby/rake) and [`Psake`](https://github.com/psake/psake).
* **CI/CD Integration:** Automated testing configurations designed for [`GitHub Actions`](https://github.com/features/actions) and local testing via [`Act`](https://github.com/nektos/act).
* **Meta-Installers:** Dynamic generation tools that automatically compile custom deployment and installation scripts.
* **Compilation Automation:** Optimized [`Makefiles`](https://makefiletutorial.com/) for streamlined, reproducible source compilation.
* **Educational Resources:** A curated collection of novice-to-intermediate programming language lessons.

## Tutorials

This tutorial introduces core scripting automation modeled after foundational [POSIX Shell](http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html) system administration tasks.

Designed both as a beginner's guide and a quick-reference handbook, these lessons cover essential programming patterns across major historical and modern scripting environments. Readers will learn practical automation for both Linux/Unix and Windows operating ecosystems.

## CI-Box (Continuous Integration)

The **CIBox** area are Continious Integration scripts currently supporting **[GHA](https://github.com/features/actions)** for automated testing, and local testing with **[Act](https://github.com/nektos/act)**. 

* [cibox/README.md](cibox/README.md)

## Script-Box 

The **ScriptBox** area contains tools and scripts that may be useful in this tutorial.  Some hightlihgts include: 

* `generate_install_sh.rb` - generates an installer script for your environment, suuch as Ubuntu 22.04. 
* `validate_commands.rb` - validate installation or availability of all languages used in this guide 
* `compile_check.rb` - will test the Makefiles in parallel (threads) for C++, C#, Java, Go, Rust.
* `run_all_tests.ps1` - will run all the tets using the test harness (`TestBox.psm1`) with `psake`
* `run_all_tests.rb` - will all the tests using the test harness (`Script.rb`) with `rake`

Further Information:

* [scriptbox/README.md](scriptbox/README.md)

## Test-Box

The **TestBox** area contains the test harnesses used to test these languages. 

* Ruby-based Test Harness (`Script.rb`) and uses `rake` to execute the tests 
* Powershell-based Test Harness (`Testbox.psm1`) and uses `Invoke-psake` to execute the tests 
* Test Plan (`expected.json`) is list of inputs (`stdin`, args), outputs (`stdout`, `stderr`), and environments variables. 
* Test Titles (`titles.json`) are descriptive titles for the tests. 

These scripts will test the environment (macOS, Linux, Windows, Cygwin, MSYS2, WSL) and then execute the tests appropriately. 

Further Information: 

* [testbox/README.md](testbox/README.md)

## Lesson Languages

### The Languages

These are the languages supported.

* **General Languages**:
  * 📜 AWK
  * ☕ Groovy&sup1;
  * 🐫 Perl
  * 🐘 PHP
  * 🐍 Python
  * 💎 Ruby
  * 📜 TCL (Tool Command Language)
* **Shell Languages**:
  * 🐚 Bourne Again Shell (bash)&sup2;
  * 🐚 C Shell (csh)&sup2;
  * 🐚 Korn Shell (ksh)&sup2;
  * 🐚 Shell, POSIX (sh)&sup2;
  * 🐚 Z Shell (zsh)&sup2;
* **Windows Languages**:
  * 📜 Command Shell (BATCH)&sup3;
  * 📜 JScript (WSH)&sup3;
  * 📜 PowerShell
  * 📜 VBScript (WSH)&sup3;
* **Compiled Languages**:
  * ➕ C++
  * 🎼 C#&sup4;
  * 🦫 Go
  * ☕ Java&sup1;
  * 🦀 Rust

1. Requires JDK environment to compile or run.
2. Utilities available with either [POSIX Utilities](http://pubs.opengroup.org/onlinepubs/009696699/utilities/contents.html) or [GNU Core-Utils](http://www.gnu.org/software/coreutils/) may be used.
3. Requires a Windows environment or translations (WINE) 
4. Requires Dotnet SDK environment to compile or run.

### The Lessons

These are the overall plan for 14 topics and about 47 lessons (varies per language support for functionality):

#### Part I

This covers the basics of input/output, logic flow, variables, and data structures (arrays, associative arrays).

* 📚 Output
  * 📗 Standard Output [A00]
  * 📗 Standard Error [A10]
  * 📗 Here Document (Multiline Output) [A20]
* 📚 Variables
  * 📗 String Concatenation [B00]
  * 📗 Variable Interpolation [B10]
  * 📗 Formatting [B20]
  * 📗 Here String (Multiline String) [B30]
* 📚 Arithmetic
  * 📗 Basic Arithmetic [C00]
  * 📗 Boolean Logic [C10]
  * 📗 Exponential [C20]
  * 📗 Math Function [C30]
* 📚 Input
  * 📗 Reading a Line [D00]
  * 📗 Reading a Single Character [D10]
* 📚 Branching
  * 📗 Branch on String [E00]
  * 📗 Ternary [E10]
  * 📗 Branch on Number Range [E20]
  * 📗 Branch on Number [E30]
  * 📗 Multiway Branch on Number [E40]
  * 📗 Multiway Branch on String Pattern [E50]
  * 📗 Branch on String Pattern [E60]
* 📚 Looping
  * 📗 Collection Loop [F00]
  * 📗 Count Loop [F10]
  * 📗 Conditional Loop [F20]
  * 📗 Spin Loop [F30]
  * 📗 Skipping [F40]
* 📚 Arrays
  * 📗 Assign by Index and Length [G00]
  * 📗 Assign by List and Enumeration by Item [G10]
  * 📗 Assign by List and Enumeration by Index [G20]
* 📚 Associative Arrays
  * 📗 Assign by Key [H00]
  * 📗 Assign by List and Appending [H10]

#### Part II  

This covers sub-routines and functions, passing values (parameters), and retrieving data. This also covers parsing command line arguments.

* 📚 Sub-Routines
  * 📗 Creation and Calling [I00]
  * 📗 Global Variable (Scope) [I10]
  * 📗 Local Variable (Scope) [I20]
* 📚 Arguments from the Command Line
  * 📗 Usage Statement (Script Name and Arg Count) [J00]
  * 📗 Enumerate Arguments in Order [J00]
  * 📗 Enumerate Arguments in Reverse Order [J10]
* 📚 Parameters
  * 📗 Pass a Single Parameters [K00]
  * 📗 Pass Variable Number of Parameters [K10]
* 📚 Exit
  * 📗 Returning an Exit Status Code [L00]
* 📚 Functions [M00]
  * 📗 Return an Integer [M00]
  * 📗 Return a String [M10]
  * 📗 Return an Array [M20]

### Part III  

This section is under development, and may be put into another advance scripting section.  As such, material is being developed for it.  Areas important for basic system administration chores will be configuring environment variables, and having more advance command line argument processing with options and flags.

* 📚 Environment Variables
  * 📗 Enumerating Variables [N00]
  * 📗 Enumerating Paths [N10]
  * 📗 Augmenting Variables [N20]
  * 📗 Exporting Variables [N30]
* 📚 Options [O00]
  * 📗 Flags [O00]
  * 📗 Options [O10]
  * 📗 Long Form [O20]
