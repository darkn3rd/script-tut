# Scripting Tutorial: Ksh (Korn Shell)

© Joaquin Menchaca, 2014

Version 1.5

## Overview

OVERVIEW

## Gettting Korn Shell on Mac OS X

Mac OS X 10.8.5 comes with Ksh '93 93u (2011-02-08).

### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install a variety of scripting languages and tools, which includes a newer version of Korn Shell.

Homebrew and Ksh 93u+ can be installed with these commands (Tested on Mac OS X 10.8.5 on July 2014):

```bash
# Installation of HomeBrew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile
# installation of Korn Shell
brew install ksh
# idea borrowed from bash
echo export KSH_VERSION=$(ksh --version 2>&1 | cut -d' ' -f15-16) >> ~/.bash_profile
. ~/.bash_profile
```

## Getting Korn Shell on Windows

Korn shell is available directly from AT&T Research Labs: http://www2.research.att.com/sw/download/.

The site is really confusing to navigate, and I could not recall how I eventually found binary installers.  At some point I stumbled upon two installers that will ksh 93u+:

* uwin-base.2012-08-06.win32.i386.exe
* uwin-base.2012-08-06.win32.i386-64.exe

After installation, ```ksh.exe``` will be installed into ```C:\Program Files\UWIN\usr\bin\``` along with other tools.


## Testing

* :dvd: *__OS X 10.8.5 (Mountain Lion)__*
  * :cd: 93u 2011-02-08 (bundled with operating system)
  * :beer: 93u+ 2012-08-01 (homebrew: `brew install ksh`)
* :dvd: *__Cent OS 6.5__*
  * :pacakge: 93u+ 2012-08-01 (yum: `sudo yum -y install ksh`)
* :dvd: *__Windows 7__* (Windows NT 6.1)
  * :package: UWIN Base 2012-08-06


## Testing on MSYS2/Windows (mksh)

The `ksh` on MSYS2 (`pacman -S ksh`, at `/usr/bin/ksh.exe`) is **mksh** (MirBSD Korn Shell), a ksh88-compatible implementation - not ksh93. These lessons were written against ksh93, so a handful of tests fail here purely because they exercise ksh93-only features mksh never implemented (confirmed directly against this `ksh.exe`, not just inferred from the diff):

* **C20/C21/C30/C31** (`c2*`/`c3*.arithmetic.ksh`) - use ksh93's built-in math functions in arithmetic expansion (`pow()`, `acos()`, `cos()` inside `$(( ))`). mksh's `$(( ))` has no math-function support at all, so the script aborts with a syntax/arithmetic error and produces no output.
* **F10** (`f10.loop.ksh`) and **J11/J21** (`j11`/`j21.arguments.ksh`) - use `{10..1}`/`{1..$n}` brace-range expansion (a ksh93/bash extension). mksh has no brace expansion, so the literal `{10..1}` text is used as the loop value instead of being expanded into a range.
* **F40** (`f40.loop.ksh`) - uses the ksh93 extended-regex match operator `[[ $var = ~(E)pattern ]]`. mksh doesn't recognize `~(E)`, so the script fails with a syntax error before it can prompt for input.
* **H00/H10** (`h00`/`h10.associative.ksh`) - use `typeset -A` (associative arrays) and the ksh93 compound-array literal `arr=([key]=value ...)`. mksh has no associative arrays; `typeset -A` errors as an unknown option, and the script silently falls back to treating `ages[bob]`/`ages[ed]` as an ordinary indexed array where every non-numeric subscript evaluates to index `0`, so all keys collapse into a single overwritten element.
* **K00** (`k00.parameters.ksh`) - uses `typeset -F` to coerce a parameter to a float. mksh errors on `-F` as an unknown option, leaving the variable unset, so the Fahrenheit-to-Celsius arithmetic silently runs on `0` instead of the intended value.

These are left as-is rather than "fixed": rewriting them to avoid ksh93 features would defeat the point of the ksh93 lesson, and the failures are a genuine, well-understood capability gap between ksh88 and ksh93, not a bug in the script or the test harness. Run these lessons under a real ksh93 (e.g. `brew install ksh` on macOS, `yum install ksh` on CentOS, or UWIN on Windows per above) to see them pass.

## Topics with Details

This covers notes regarding each section.

1. **Output**
2. **Variables**
3. **Arithmetic**
4. **Input**
5. **Branch**
6. **Looping**
7. **Arrays**
8. **Associative Arrays**
9. **Subroutines**
10. **Arguments**
11. **Parameters**
12. **Functions**
