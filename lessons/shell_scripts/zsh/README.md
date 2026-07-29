# Scripting Tutorial: Zsh (Z Shell)

© Joaquin Menchaca, 2014-2026

Version 1.0

## Overview

*Z Shell* (zsh) written by Paul Falstad and released in 1990, combines ideas from bash, ksh, and tcsh, and adds its own extensive set of extensions (advanced globbing, a rich parameter-expansion flag system, programmable completion). Since macOS Catalina (2019), zsh is the default login shell on macOS, replacing bash.

Zsh is not a POSIX-compliant shell by default, though it can approximate one via `emulate sh`/`emulate ksh` or by enabling specific compatibility options (e.g. `setopt KSH_ARRAYS`, used by a couple of lessons here - see "Notes on zsh vs bash" below). Left in its native mode (as these lessons are), zsh differs from bash in several places that matter for this tutorial: array indexing, associative-array key syntax, and how `$0` behaves inside a function.

## Getting Zsh on Mac OS X (macOS)

macOS ships zsh at `/bin/zsh`, but it is not necessarily the newest release.

### Homebrew

Homebrew can install a newer zsh separately from the system one:

```bash
brew install zsh
```

## Getting Zsh on Windows 11

Zsh is available in **[MSYS2](https://www.msys2.org/)** via `pacman -S zsh`, or in **[Cygwin](https://www.cygwin.com/)** via its installer's package selection.

## Testing

* :dvd: *__macOS 26.5 (Tahoe)__*
  * :package: zsh 5.9.1 (homebrew: `brew install zsh`)
  * :computer: zsh 5.9 (bundled with operating system, `/bin/zsh`)

## Notes on zsh vs bash

These lessons were ported from [../bash](../bash/README.md), and every one of them passes under zsh - but a handful needed adapting first, since zsh's native (non-`KSH_ARRAYS`, non-`emulate`) behavior genuinely differs from bash's in these spots:

* **G00/G20** (`g00`/`g20.array.zsh`) - zsh arrays are 1-indexed by default, and assigning index `0` directly (`nicknames[0]=bob`) is a hard error ("assignment to invalid subscript range"), not just an off-by-one. Both scripts add `setopt KSH_ARRAYS` to get 0-indexed arrays back.
* **O20/O21** (`o20`/`o21.longform.zsh`) - same 1-indexed issue, plus `"${!names[@]}"` (bash's "list the indices" syntax) is a bad substitution in zsh regardless of `KSH_ARRAYS`. Fixed the same way as G00/G20 (`setopt KSH_ARRAYS`), with the index loop rewritten as a C-style `for (( i=0; i<...; i++ ))` instead of iterating `"${!names[@]}"`.
* **H00/H10** (`h00`/`h10.associative.zsh`) and **N20** (`n20.setvars.zsh`) - `"${!array[@]}"` (bash's "list the keys" of an associative array) is likewise unsupported; zsh's equivalent is the `${(k)array[@]}` parameter flag.
* **N10** (`n10.getpath.zsh`) - `read -ra` (bash's "split into this array" flag) is a bad option in zsh; the equivalent is `read -rA` (uppercase).
* **D10** (`d10.input.zsh`) - `read -n 1` (bash's "read this many characters") means something unrelated in zsh (a completion-context flag). The zsh equivalent, `read -k 1`, additionally insists on opening the real terminal unless paired with `-u 0` to read from stdin's file descriptor directly - needed since the test harness pipes input rather than typing at a live terminal.
* **O00/O10/O20/O21** (`o0*.flags.zsh`, `o10.options.zsh`, `o2*.longform.zsh`) - all four `usage()` functions read `$0` to print the script's own name. zsh (unlike bash) sets `$0` to the *function's* name inside a function by default, so `$(basename "$0")` inside `usage()` printed `usage`, not the actual filename. Fixed by capturing `script_name=$(basename "$0")` once at top level (outside any function) and referencing that variable from inside `usage()`.
* **B20** (`b20.variables.zsh`) - `printf "...\'%c\'...\n"` relied on bash's `printf` silently swallowing the backslash before an already-unspecial `'`. zsh's `printf` doesn't do that, so it printed the backslash literally. Fixed by just dropping the unneeded escapes (a single quote needs no escaping inside a double-quoted string in either shell).
* **M11** (`m11.function.zsh`) - the original branched on `$BASH_VERSION` (unset under zsh, so the arithmetic test itself errored) to choose between a `tr` fallback and bash 4's `${1^^}` uppercase expansion (a bad substitution in zsh - it doesn't exist there). Replaced entirely with zsh's own `${(U)1}` uppercase parameter flag.

None of these are capability gaps (contrast with [../ksh/README.md](../ksh/README.md)'s notes on mksh) - zsh can do everything bash's version of each lesson does, just with different syntax.

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
12. **Exit**
13. **Functions**
14. **Options**
15. **Environment Variables**
