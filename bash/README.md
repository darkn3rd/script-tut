# Scripting Tutorial: Bash (Bourne Again Shell)

© Joaquin Menchaca, 2014

Version 1.5

## Overview

*Bourne Again Shell* (bash) written by Brian Fox and releated in 1989 as a drop-in replacement for the original shell *Bourne Shell* (sh).  Bash extends the shell with new features, mixing in ideas borrowed from C Shell (csh) and Korn Shell (ksh).

Bash is compatible as a POSIX shell and will run in strict POSIX mode when accessed as ```sh```.  There may have been non-portable features that still work in this mode, and such features are called bashisms.

Bash 4 adds a number of features, such as associative arrays and new parameter expansions to do uppercase and lowercase on variables.  Earlier Bash 3 supported arrays, but could not use associative arrays.

## Getting Bash on Mac OS X

Mac OS X 10.8.5 comes with GNU Bash 3.2.48.

### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install a variety of scripting languages and tools, which includes Bash 4.

Homebrew and Bash 4 can be installed with these commands (Tested on Mac OS X 10.8.5):

```bash
# Install HomeBrew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile
# Install Bash 4
brew install bash
# BASH_VERSION is not updated, so we update manually
echo export BASH_VERSION=$(bash -version | head -1 | cut -d' ' -f4) >> ~/.bash_profile
. ~/.bash_profile
```

## Getting Bash on Windows

### GitBash (MSYS)

An easy way to get Bash on Windows is to use Git Bash from msysgit from http://msysgit.github.io/.  This installs a set of Mingw GNU tools.  Currently (July 2014), Mingw has an earlier version of GNU bash 3.1.0.

When running Git Bash on Windows, you might notice that some paths in the ```$PATH``` still have Windows path names.  This happens when the Windows ```%PATH%``` includes other variables, such as ```%JAVA_HOME%```.  

To fix this, you can source this script to fix that situation if this occurs:

```bash
#!/bin/sh
# convert DOS style %varibles% to UNIX style ${variables}
NEWPATH=$(echo "$PATH" | sed 's/%\([^%]*\)%/${\1}/g')

# resolve all variables in $PATH
eval NEWPATH=\"${NEWPATH}\"

# convert DOS paths (C:\path\) to UNIX paths (/c/path/)
PATH="$(echo "${NEWPATH}" | sed \
   -e 's@^\([a-zA-Z]\):\\@/\L\1/@g' \
   -e 's@:\([a-zA-Z]\):\\@:/\L\1/@g' \
   -e 's@\\@/@g')"

export PATH
```
Reference: https://github.com/darkn3rd/opscripts/blob/master/windows/git_bash_path_fix.windows.sh

## Testing

* Mac OS X 10.8.5

```bash
$ /bin/bash -version | head -1
GNU bash, version 3.2.48(1)-release (x86_64-apple-darwin12)
$ /usr/local/bin/bash -version | head -1
GNU bash, version 4.3.18(1)-release (x86_64-apple-darwin12.5.0)
```

## Topics with Details

* :books: Output
  * :green_book: Standard Output [A00]
  * :green_book: Standard Error [A10]
  * :green_book: Multi-Line (Here Doc) [A20]
* :books: Variables
  * :green_book: String Concatenation [B00]
  * :green_book: String Interpolation [B10]
  * :green_book: String Formatting [B20]
  * :green_book: Multiline String (Here String) [B30]
* :books: Arithmetic
  * :green_book: Basic Arithmetic [C00]
  * :green_book: Boolean Logic [C10]
  * :green_book: Exponential [C20] ***Uses `bc`***
  * :green_book: Math Function [C30] ***Uses `awk`***
* :books: Input
  * :green_book: Reading a Line [D00]
* :books: Branching
  * :green_book: Branch on String [E00]
  * :green_book: Boolean Logic Alernative [E10]
  * :green_book: Branch on Number Range [E20]
  * :green_book: Branch on Number
     * :page_facing_up: Numerical Evaluation using `(( == ))` [E30]
     * :page_facing_up: Numerical Evaluation using `[[ -eq ]]` [E31]
     * :page_facing_up: Character Evaluation using `[[ = ]]` [E32]
  * :green_book: Multiway Branch on Number [E40]
  * :green_book: Multiway Branch on String Pattern
    * :page_facing_up: ASCII Character Class [E50]
    * :page_facing_up: POSIX Character Class (Unicode) [E51]
  * :green_book: Branch on String Pattern
    * :page_facing_up: ASCII Character Class [E60]
    * :page_facing_up: POSIX Character Class (Unicode) [E61]
* :books: Looping
  * :green_book: Collection Loop [F00]
  * :green_book: Count Loop
      * :page_facing_up: Loop with `for ( ; ; )` [F10]
      * :page_facing_up: Loop with `for in {..}` [F11]
      * :page_facing_up: Loop with `while ()` [F12]
  * :green_book: Conditional Loop
      * :page_facing_up: Loop with `until..do..done` [F20]
      * :page_facing_up: Loop with `while..do..done` [F21]
  * :green_book: Spin Loop [F30]
  * :green_book: Skipping with `continue` [F40]
* :books: Arrays
  * :green_book: Assign by Index and Length [G00]
  * :green_book: Assign by List and Enumeration by Item [G10]
  * :green_book: Assign by List and Enumeration by Index [G20]
* :books: Associative Arrays
  * :green_book: Assign by Key [H00]
  * :green_book: Assign by List and Appending [H10]
* :books: Sub-Routines
  * :green_book: Creation and Calling [I00]
* :books: Arguments (Command Line)
  * :green_book: Usage Statement (Script Name and Arg Count) [J00]
  * :green_book: Enumerate Arguments in Order
    * :page_facing_up: Collection Loop [J10]
    * :page_facing_up: Count Loop with range [J11]
    * :page_facing_up: Count Loop with shift (count < #arg) [J12]
    * :page_facing_up: Count Loop with shift (#args > 0) [J13]
  * :green_book: Enumerate Arguments in Reverse Order
    * :page_facing_up: Count Loop with shift [J20]
    * :page_facing_up: Count Loop with range [J21]
* :books: Parameters (Sub-Routines)
  * :green_book: Pass a Single Parameters [K00]
  * :green_book: Pass Variable Number of Parameters [K10]
* :books: Exit
  * :green_book: Returning an Exit Status Code [L00]
* :books: Functions [M00]
  * :closed_book: Return an Integer
    * :page_facing_up: Use Sub-Shell to capture result [M01]
    * :page_facing_up: Use Global Variable to store result [M02]
    * :page_facing_up: Use Exit Code to store result [M03]
  * :closed_book: Return a String
    * :page_facing_up: Use Sub-Shell to capture result [M11]
