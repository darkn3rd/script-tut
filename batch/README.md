# Scripting Tutorial: BATCH (Command Shell)

© Joaquin Menchaca, 2014

Version 1.1

## Overview

This covers the Windows Command Shell, sometimes referred to as BATCH due to the similarity with historical DOS operating system.  Windows Command Shell scripts will end with the ```.CMD``` extension, but the environment will also execute scripts with the ```.BAT``` extension as well.  The scripts in this section only work with Windows Command Shell found in flavors of Windows NT.

## History

The *BATCH* environment has existed since 1981 with the releases of MS-DOS, IBM PC-DOS, and DR-DOS (Digital Research). Different versions of Windows 4.x (a.k.a. Windows '95 to Windows ME) were bundled with MS-DOS, and thus by nature included the the *BATCH* environment.

A new environment, called *Command Shell*, was introduced with the with IBM OS/2, and later with Microsoft Windows NT.  Future versions of Windows NT, marketed as Windows XP, Windows 7, Windows 8, and so forth, continue to carry the *Command Shell*.

## Historical Alternatives to Batch

The original BATCH environment was extremely limited, and was extended in a variety of ways.  In MS-DOS, many were able to compile small Assembly language scripts using ```DEBUG```, and with MS-DOS 5.0, Basic scripts using  ```QBASIC /RUN```, and in PC-DOS, there was the REXX scripting environment.  REXX was popular on mainframes and Amiga OS.  An alternative third party called 4DOS was quite popular, as well as MKS Tools, which provided Korn Shell capability to DOS. The toolset DGJPP (http://www.delorie.com/djgpp/) provided UNIX tools to DOS.  

Today, Command Shell has added features beyond its earlier BATCH cousin, but it is still quite limited.  For any heavy lifting, Microsoft has provided WSH (Windows Scripting Host) with support for languages like VBScript and JScript (JavaScript) for scripting the environment.  Also popular were languages like Perl, Python, Ruby, and KiXart (http://www.kixtart.org/).  Today, especially after Windows 2008, PowerShell has become the one ubiquitous language for modern Windows operating systems, but still the Command Shell remains popular for basic chores.

## Testing

* Windows NT 6.1 (Windows 7)

## Lessons

This is a subset of lessons for Batch (Command Shell):

* :books: Output
  * :green_book: Standard Output [A00]
  * :green_book: Standard Error [A00]
* :books: Variables
  * :green_book: String Concatenation [B00]
* :books: Arithmetic
  * :green_book: Basic Arithmetic [C00]
  * :closed_book: Boolean Logic [C11]
* :books: Input
  * :green_book: Reading a Line [D00]
* :books: Branching
  * :green_book: Branch on Number Range [E20]
  * :closed_book: Branch on String Pattern
    * :page_facing_up: Character Sets [E61] ***Uses `FindStr`***
* :books: Looping
  * :green_book: Collection Loop
    * :page_facing_up: Conditional Loop test directory listing [F00]
  * :green_book: Count Loop
      * :page_facing_up: Loop with `for in do ()` [F10]
  * :closed_book: Conditional Loop
      * :page_facing_up: Loop with `do...while()` [F21]
* :books: Sub-Routines
  * :closed_book: Creation and Calling [I01]
* :books: Arguments from the Command Line
  * :green_book: Usage Statement (Script Name and Arg Count) [J00]
  * :green_book: Enumerate Arguments in Order [J10]
* :books: Parameters (Sub-Routines)
  * :green_book: Pass a Single Parameters [K00]
  * :green_book: Pass Variable Number of Parameters [K10]
* :books: Exit
  * :green_book: Returning an Exit Status Code [L00]
* :books: Functions
  * :closed_book: Return an Integer
    * :page_facing_up: Use Exit Error Code to capture result [M01]
  * :closed_book: Return a String
    * :page_facing_up: Use Delayed Expansion to capture result [M11]

**Key**
* :books: - topic area
* :green_book: - Lesson supported by language
* :closed_book: - Not supported by language, but alternative
* :page_facing_up: - Alternative methods to do the lesson

## Notes

### Lessons Omitted

Command Shell (Batch) barely supports string variables, and certainly does not support ***arrays*** or ***associative arrays***.  

### Tidbits while Batching

* Special characters can be escaped with the carrot `^` character, and line continuations can be used with the carrot `^` placed at the end of the line.

* The original Batch never had the ability to do a sub shells and then capture output from commands executed in the sub shell.  Command Shell added this ability with the `for` loop.

* The BATCH equivalent of subroutines are accessed through `CALL` and end with `GOTO :EOF` and parameters can be passed into the subroutine.

* Some limited globbing can be performed with the external `FINDSTR` command, but like filenames, the tool cannot distinguish between lower case and upper case, so `[a-z]` is the same as `[A-Z]`.
