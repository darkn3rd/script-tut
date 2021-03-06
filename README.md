# Scripting Tutorial

© Joaquin Menchaca, 2014

## Overview

This is a basic tutorial of scripting modeled after typical tasks one would do with [POSIX Shell Programming](http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html) for system administration chores.  

This tutorial will cover the basics of programming in a variety of languages, so it may be useful as a beginner's guide to scripting and as a reference.  The target languages cover popular (either historical or current) scripting languages found on Linux/Unix and Windows oriented operating systems.

## ScriptingBox Install Guide

I created a cumulative installation guide to get all the tools needed for this tutorial for Windows and Mac OS X:

* https://github.com/darkn3rd/script-tut/blob/master/scriptbox/

## Languages

These are the languages supported.

* **General Languages**:
  * :scroll: AWK
  * :coffee: Groovy ††
  * :camel: Perl
  * :elephant: PHP
  * :snake: Python
  * :gem: Ruby
  * :scroll: TCL (Tool Command Language)
* **Shell Languages**:
  * :shell: Bourne Again Shell (bash) †
  * :shell: C Shell (csh) †
  * :shell: Korn Shell (ksh) †
  * :shell: Shell, POSIX (sh) †
* **Windows Languages**:
  * :scroll: Command Shell (BATCH)
  * :scroll: JScript (WSH)
  * :scroll: PowerShell †††
  * :scroll: VBScript (WSH)

† Utilities available with either [POSIX Utilities](http://pubs.opengroup.org/onlinepubs/009696699/utilities/contents.html) or [GNU Core-Utils](http://www.gnu.org/software/coreutils/) may be used.

†† Requires JVM (Java Virtual Machine) environment to run.

††† Requires CLR (Common Language Runtime) environment to run.

## The Lessons

These are the overall plan for 14 topics and about 47 lessons (varies per language support for functionality):

### Part I

This covers the basics of input/output, logic flow, variables, and data structures (arrays, associative arrays).

* :books: Output
  * :green_book: Standard Output [A00]
  * :green_book: Standard Error [A10]
  * :green_book: Here Document (Multiline Output) [A20]
* :books: Variables
  * :green_book: String Concatenation [B00]
  * :green_book: Variable Interpolation [B10]
  * :green_book: Formatting [B20]
  * :green_book: Here String (Multiline String) [B30]
* :books: Arithmetic
  * :green_book: Basic Arithmetic [C00]
  * :green_book: Boolean Logic [C10]
  * :green_book: Exponential [C20]
  * :green_book: Math Function [C30]
* :books: Input
  * :green_book: Reading a Line [D00]
  * :green_book: Reading a Single Character [D10]
* :books: Branching
  * :green_book: Branch on String [E00]
  * :green_book: Ternary [E10]
  * :green_book: Branch on Number Range [E20]
  * :green_book: Branch on Number [E30]
  * :green_book: Multiway Branch on Number [E40]
  * :green_book: Multiway Branch on String Pattern [E50]
  * :green_book: Branch on String Pattern [E60]
* :books: Looping
  * :green_book: Collection Loop [F00]
  * :green_book: Count Loop [F10]
  * :green_book: Conditional Loop [F20]
  * :green_book: Spin Loop [F30]
  * :green_book: Skipping [F40]
* :books: Arrays
  * :green_book: Assign by Index and Length [G00]
  * :green_book: Assign by List and Enumeration by Item [G10]
  * :green_book: Assign by List and Enumeration by Index [G20]
* :books: Associative Arrays
  * :green_book: Assign by Key [H00]
  * :green_book: Assign by List and Appending [H10]

### Part II  

This covers sub-routines and functions, passing values (parameters), and retrieving data. This also covers parsing command line arguments.

* :books: Sub-Routines
  * :green_book: Creation and Calling [I00]
  * :green_book: Global Variable (Scope) [I10]
  * :green_book: Local Variable (Scope) [I20]
* :books: Arguments from the Command Line
  * :green_book: Usage Statement (Script Name and Arg Count) [J00]
  * :green_book: Enumerate Arguments in Order [J00]
  * :green_book: Enumerate Arguments in Reverse Order [J10]
* :books: Parameters
  * :green_book: Pass a Single Parameters [K00]
  * :green_book: Pass Variable Number of Parameters [K10]
* :books: Exit
  * :green_book: Returning an Exit Status Code [L00]
* :books: Functions [M00]
  * :green_book: Return an Integer [M00]
  * :green_book: Return a String [M10]
  * :green_book: Return an Array [M20]

### Part III  

This section is under development, and may be put into another advance scripting section.  As such, material is being developed for it.  Areas important for basic system administration chores will be configuring environment variables, and having more advance command line argument processing with options and flags.

* :books: Environment Variables
  * :green_book: Enumerating Variables [N00]
  * :green_book: Enumerating Paths [N10]
  * :green_book: Augmenting Variables [N20]
  * :green_book: Exporting Variables [N30]
* :books: Options [O00]
  * :green_book: Flags [O00]
  * :green_book: Options [O10]
  * :green_book: Long Form [O20]
