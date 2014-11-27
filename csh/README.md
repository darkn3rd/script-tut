# Scripting Tutorial: C Shell

© Joaquin Menchaca, 2014

Version 1.3

## Overview

Welcome to C Shell tutorial.  This will teach the basics on how to get around in C Shell scripting.

## Getting C Shell on Mac OS X

Mac OS X 10.8.5 comes with TCsh 6.17.00 (Astron) built on 2009-07-10.

## History

C Shell was created by Bill Joy in the 1970s and was distributed with BSD UNIX and went on to become the default shell for BSD UNIX flavors.  C Shell became popular both for its C language-like syntax, and rich and easy to use customization.  

C Shell is widely known to have problems and limitations, and does not have basic features like functions.  So many may have opted out from using C Shell for any professional scripting, but still used the shell environment to interface with UNIX and Linux systems.  Today, C Shell has not fixed many of its issues (which probably requires a rewrite)
and it is unable to keep up with robust feature set afforded in other shells.

## Language Quirks

The language itself has posed some quirks that are not some randomly discovered bug, but are the actual behavior.  Two that I found quite profound.  Any reserved word that terminates a block, absolutely must be followed by a newline.  If it is not, weird stuff happens.  Spaces followed by one of these block terminators, such as ```endif``` or ```end```, will also cause the block to fail.  Also, found out that when processing input, ```set variable=$<```, only the first word is captured, and a quoted string with spaces causes ```set: Syntax Error.```.

Beyond these quirks, the language is extremely limited.  Here are a few of the limitations I have found:

  * cannot store any type of float, even as a string.  Thus "3.14" can never be saved into any variable, even if used as a string.
  * NO functions or subroutines (clever hacks with alias and goto is a workaround)
  * arrays items cannot be inserted by index, they must be concatenated into an existing array.
  * arrays items can be retrieved by an index.

Lastly, besides BATCH programming, this language has the ***LEAST*** capabilities of any scripting language.  There are reasons many a system administrator are saying "*don't use it*". Unless job security is needed, such as C Shell that spawns Awk scripts that sub-shell perl one-liners that may call C Shell again, I don't see the utility... :)

And anyone documenting C Shell, it seems it is traditional to reference this document:

  * **[Top Ten Reasons Not to Use the C shell](http://www.grymoire.com/unix/CshTop10.txt)** by Bruce Barnett.

## Why Document C-Shell At All?

I know someone one is thinking of this...

I wanted to document this for these reasons that come to mind: (1) nostalgia, (2) hardly any documentation out there, (3) comparison, and (4) completeness.  In pre-Linux days, BSD Unix was quite popular and thus the C-Shell that came with it was quite popular.  

When I started out, I used to use C-Shell on [68K](http://en.wikipedia.org/wiki/Motorola_68000_series) [Macintoshes](http://en.wikipedia.org/wiki/Macintosh) with either   [MachTen](http://www.tenon.com/products/machten/) or [NetBSD](http://www.netbsd.org/), and on [PC clones](http://en.wikipedia.org/wiki/IBM_PC_compatible), I used it on [NeXTSTEP](http://en.wikipedia.org/wiki/NeXTSTEP) 3.3.

## Topics

* :books: Output
  * :green_book: Standard Output [A00]
  * :closed_book: Standard Error [A11]
* :books: Variables
  * :green_book: String Concatenation [B00]
  * :green_book: Variable Interpolation [B10]
  * :green_book: Formatting [B20]
  * :green_book: Here String (Multiline String) [B30]
* :books: Arithmetic
  * :green_book: Basic Arithmetic [C00]
  * :green_book: Boolean Logic [C10]
* :books: Input
  * :green_book: Reading a Line [D00]
* :books: Branching
  * :green_book: Branch on Number Range [E20]
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
* :books: Arguments from the Command Line
  * :closed_book: Usage Statement (Script Name and Arg Count) [J01]
  * :green_book: Enumerate Arguments in Order [J10]
  * :green_book: Enumerate Arguments in Reverse Order [J20]

## Notes

These are things I discovered in developing C-Shell material.

* C-Shell simulates *array* functionality using space-delimited strings, which can be processed using a collection loop or through an index.
* C-Shell definatley does not suport *associative arrays*.
* C-Shell does not support *subroutines* or *functions*.  There might be some clever hacks with `alias` or `goto :label` to get some of this functionality.
