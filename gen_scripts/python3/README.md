# Scripting Tutorial: Python 3

Version 1.0

© Joaquin Menchaca, 2014-2026

This is a Python 3 port of the [Python 2 tutorial](../python2/), updated to
current, supported Python syntax (`print()` as a function, `input()`,
f-strings-friendly idioms, etc.).

## Getting Python

### macOS

macOS no longer ships a system Python. Install Python 3 with one of:

* Homebrew [https://brew.sh/]: `brew install python3`
* The official installer from https://www.python.org/downloads/
* [pyenv](https://github.com/pyenv/pyenv) if you need to manage multiple versions

### Linux

Most distributions ship Python 3 by default (`python3 --version`). If not,
install it via your package manager, e.g. `apt install python3` (Debian/Ubuntu)
or `dnf install python3` (Fedora/RHEL).

### Windows

Install from https://www.python.org/downloads/ (check "Add python.exe to PATH")
or via the Microsoft Store.

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
     * **OMITTED**: *Python does not have a mechanism for this*
   * multi-way test on single character with pattern matching
     * **OMITTED**: *Python does not have a mechanism for this*
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
