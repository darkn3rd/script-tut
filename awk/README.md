# Scripting Tutorial: AWK

© Joaquin Menchaca, 2014

Version 1.5

## Overview

The AWK tool was introduced in Version 7 Unix and named after the authors: Aho, Weinberger, and Kernighan.  AWK provided computational features to the Unix pipeline, and at the time, AWK was the only other scripting language available besides Bourne Shell.  

AWK was extremely popular in the 1970s and 1980s.  The available shell at the time (Bourne shell) was extremely limited, and AWK provided numerous capabilities absent from Bourne Shell.  This included rich text processing capabilities, math functions, and the capability to create arrays and associative arrays (hashes).

AWK was updated in the late 1980s with the release of nawk (New AWK) and gawk (GNU AWK).  New AWK is available on SVR Unix versions, while GNU AWK is widely available, especially in open source systems like Linux.  In the 1990s, the popularity of Perl caused AWK to be used less for text-processing chores.

GNU Awk is continues to be updated.  Gawk 3.1.5 added the ability to get the size of an array with `length()`, where before this only worked on strings.  Also, Gawk 4.0 adds use of `switch() { ... }`.

### Articles and Resources on Awk

* GNU Awk: This is not Your Father's Awk: http://www.drdobbs.com/open-source/gnu-awk-this-is-not-your-fathers-awk/240158351
* GNU Awk Manual: http://www.gnu.org/software/gawk/manual/gawk.pdf

## Getting AWK

Today, AWK is found on many Linux systems.  For UNIX systems or systems claiming to have POSIX compatibility, would likely have awk as apart of that tool set for compliance toward [IEEE Std 1003.1, 2013 Edition](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/contents.html).

Thus, with any UNIX or Linux system, you can expect awk to be available.  For Windows, that is another matter.  You can get awk from a number of locations.  

### Getting AWK on Windows

For Windows, you can run GNU in various environments, some mimicking a Unix-like environment on Windows:

 * **[CygWin](https://www.cygwin.com/)** - robust environment uses special library to provide Unix compatibility.  
 * **[GitBash](http://msysgit.github.io/)** - Git tools that bundles the MSYS environment (http://www.mingw.org/wiki/msys) that provides Bash shell and some GNU tools including GNU Awk.
 * **[GNUWin32](http://gnuwin32.sourceforge.net/)** - GNU tools that work directly from Command Shell.
   * GNUWin32 Gawk - http://gnuwin32.sourceforge.net/packages/gawk.htm
 * **[UWIN](http://www2.research.att.com/sw/download/)** - toolset comes directly from AT&T and provides tools that are found with SVR4 Unix systems.  Tools seem to only work within their environment, i.e. `login.exe` program.
   * Installer - http://www2.research.att.com/~astopen/download/tgz/uwin-base.2012-08-06.win32.i386-64.exe

```batch
C:\> "C:\Program Files (x86)"\GnuWin32\bin\gawk --version | head -1
GNU Awk 3.1.6
C:\>"C:\Program Files (x86)\Git\bin\gawk.exe" --version | head -1
GNU Awk 3.0.4
```


### Getting AWK on Macintosh

OS X 10.8.5 comes with a version of AWK that is normally distributed with BSD flavors of UNIX.  The newer features found in GAWK will not be available.  Thus you can use a tool like HomeBrew to grab the latest version of GAWK.  Here's a sample run of this on July, 2014:

```bash
$ brew install gawk
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/gawk-4.1.1.mountain_lion.bottle.tar.gz
######################################################################## 100.0%
==> Pouring gawk-4.1.1.mountain_lion.bottle.tar.gz
🍺  /usr/local/Cellar/gawk/4.1.1: 61 files, 2.8M
```

### Getting AWK on CentOS 6.5 (or RHEL 6.5)

The default awk that comes with Cent OS 6.5 is extremely old:

```
/bin/awk --version | head -1
GNU Awk 3.1.7
```


## How It Works

AWK is quite different in that an AWK script works as a filter.  This means AWK scripts are oriented to receive text from the console, standard-input.  Thus AWK scripts are generally not interactive scripts, where you selectively read lines of input.  Thus most awk scripts will be run with input being sent directly into the script. Examples:

```
some_command | awkscript
awkscript < somefile.txt
```

AWK scripts have the ability to do pre-processing and post-processing before and after receiving input through the `BEGIN` and `END` blocks.  These tutorial scripts here will use the `BEGIN` blocks.  These tutorial scripts illustrate that AWK in and of itself is a powerful scripting language, and have the capabilities shared by other modern scripting languages.

## Issues

Environments will have AWK in either `/bin/awk` or `/usr/bin/awk` or both.  These scripts expect AWK to be in `/bin/awk`.  The workaround, provided you have administration privileges is to add a symbolic link.

On Mac OS X 10.8.5, you can do this:
`
sudo ln -s `which awk` /bin/awk
`

## Testing

* :dvd: Windows 7 (32-bit),
  * :package: Gawk 3.0.4 (msysgit 1.9.2-preview20140411)
    * :beetle: `length()` only works on string, will not work on array
  * :package: Nawk (UWIN 2012-08-06)
    * :beetle: `length()` only works on string, will not work on array
  * :package: GNUWin32, GNU Awk 3.1.6
    * :beetle: `length(array)` does not work.
    * :beetle: last file from `ls` is not $9, but $8, so use $NF instead
    * :beetle: UNIX `date` needs to be in the path.  Unix date is available with MSYS environment.
* :dvd: OS X 10.8.5
　 * :package: BSD Awk 20070501 (bundled with OS)
     * :beetle: awk not in `/bin/awk`, but found in `/usr/bin/awk`
* :dvd: CentOS 6.5
  * :package: GNU Awk 3.1.7
    * :beetle: `switch` will not work as requires GNU Awk 4.0 and above.


## Topics

* :books: Output
  * :green_book: Standard Output [A00]
  * :closed_book: Standard Error [A11] ***GAWK only***
* :books: Variables
  * :green_book: String Concatenation [B00]
  * :green_book: Formatting [B20]
* :books: Arithmetic
  * :green_book: Basic Arithmetic [C00]
  * :green_book: Boolean Logic [C10]
  * :green_book: Exponential [C20]
  * :green_book: Math Function [C30]
* :books: Input
  * :green_book: Reading a Line [D00]
* :books: Branching
  * :green_book: Branch on String [E00]
  * :green_book: Ternary [E10]
  * :green_book: Branch on Number Range [E20]
  * :green_book: Branch on Number [E30]
  * :closed_book: Multiway Branch on Number [E41] ***GAWK only***
  * :closed_book: Multiway Branch on String Pattern
    * :page_facing_up: Character Sets [E51] ***GAWK only***
    * :page_facing_up: POSIX Character Sets [E52] ***GAWK only***
  * :green_book: Branch on String Pattern
    * :page_facing_up: Character Sets [E60]
    * :page_facing_up: POSIX Character Sets [E61]
* :books: Looping
  * :closed_book: Collection Loop
    * :page_facing_up: Conditional Loop test directory listing [F01]
  * :green_book: Count Loop
      * :page_facing_up: Loop with `for ( ; ; )` [F10]
      * :page_facing_up: Loop with `while ()` [F11]
  * :green_book: Conditional Loop [F20]
      * :page_facing_up: Loop with `do...while()` [F10]
      * :page_facing_up: Loop with `while ()` [F11]
  * :green_book: Spin Loop [F30]
  * :green_book: Skipping [F40]
* :books: Arrays
  * :green_book: Assign by Index and Length [G00]
      * :page_facing_up: helper function to count array items [G00]
      * :page_facing_up: ***Gawk's*** `length()` [G01]
  * :green_book: Assign by List and Enumeration by Item [G10]
  * :green_book: Assign by List and Enumeration by Index [G20]
      * :page_facing_up: helper function to count array items [G00]
      * :page_facing_up: ***Gawk's*** `length()` [G01]
* :books: Associative Arrays
  * :green_book: Assign by Key [H00]
  * :green_book: Assign by List and Appending [H10]
* :books: Sub-Routines
  * :green_book: Creation and Calling [I00]
  * :green_book: Global Variable (Scope) [I10]
  * :green_book: Local Variable (Scope) [I20]
* :books: Arguments from the Command Line
  * :closed_book: Usage Statement (Script Name and Arg Count) [J01] ***GAWK only***
  * :green_book: Enumerate Arguments in Order [J00]
  * :green_book: Enumerate Arguments in Reverse Order [J10]
* :books: Parameters
  * :green_book: Pass a Single Parameters [K00]
  * :green_book: Pass Variable Number of Parameters [K10]
* :books: Exit
  * :closed_book: Returning an Exit Status Code [L01] ***GAWK only***
* :books: Functions [M00]
  * :green_book: Return an Integer [M00]
  * :green_book: Return a String [M10]


## Details

This covers notes regarding each section.

1. **Output**
2. **Variables**
   * output variables using string concatenation with `print`
   * output variables using string interpolation with `printf`
3. **Arithmetic**
4. **Input**
5. **Branch**
   * branch on a string with `if` - yes/no
   * branch on a string with ternary
   * branch on number range
   * branch on an exact number using `if`
   * multiway branch on an exact number using `switch` (*Gawk 3.1.5+ only*)
   * multiway branch on a pattern using `switch` (*Gawk 3.1.5+ only*)
   * select on pattern using `if`
6. **Looping**
   * iterative (count) loop
   * conditional loop
   * collection loop
     * **OMITTED** *Awk does not have a true collection loop, so a conditional loop that pulls from standard-input was used as an alternative*
7. **Arrays**
   * populate array using index
   * populate array using list of items
     * **NOTES**
        * Awk does not have syntax support to declare an array on one line.  
        * `split(string, array)` function with a space delimited string will work.
   * enumerate array using collection loop
       * **NOTES**
          * Awk does not have a collection loop, but rather pulls an key from the array
          * Awk does not have real arrays, as indexes are actually strings.  The for loop, i.e.  `for (key in array)`, can pull indexes (keys) in any order.
   * enumerate array using iterative loop
       * **NOTES**
          * Awk doesn't support `length(array)`. Only available in GNU Awk (gawk) 3.1.5 and after.
          * A helper function of `array_length(array)` was created to support this.
8. **Associative Arrays**
   * Create Associative Array using key index
     * **NOTES**
        * helper function `keys()` to return string of all the keys
        * helper function `values()` to return string of all the values
   * Create Associative Array using supplied list of key and value pairs
     * **NOTES**
        * helper function of `make_array()` to create associative array from supplied string
        * helper function of `merge()` to merge two associative arrays
9. **Subroutines**
   * Demonstrating creating and calling a subroutine
     *  utilize subroutine that prints the current date in "Month Day, Year" format
   * Demonstrate global variables
     * **NOTES** *All variables in in AWK are global variables, unless passed in as parameters*
   * Demonstrate local variables
     * **NOTES** *Local varabialbes can be created by listing them in the parameter list*
10. **Arguments**
    * demonstrate testing for two arguments
    * print list of all arguments with count
      * **NOTES**
         * skipping `for (key in array)` as keys fetched out of order and ARGV contains script name.
    * print list of all arguments in reverse with count
11. **Parameters**
   * demonstrate passing 1 parameter
     * utilize subroutine that prints celsius temperature when supplied fahrenheit temperature
   * demonstrate passing unlimited parameters
     * **Note** *AWK does not support variable parameters, so an array is passed instead.*
     * utilize subroutine prints sum of all numbers passed into it.
12. **Functions**
    * demonstrate returning integer
      * returns summation of all numbers passed into function
    * demonstrate returning string
      * returns capitalized string from lower case string
