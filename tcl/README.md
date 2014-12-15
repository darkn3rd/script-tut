# Scripting Tutorial: TCL (Tool Command Language)

© Joaquin Menchaca, 2014

Version 1.4

## Overview

TCL or Tool Command Language, pronounced as *tickle*, was created by John Ousterhout in 1988.  The language was initially used for embedded systems automation, such as testing small independent tools.  

TCL (*tickle*) achieved enormous popularity in the 1990s with the release of the Tk GUI toolkit in 1991.  At the time the common toolsets for creating graphics required were complex and required compiling platform specific code using libraries for libraries [X Window System](http://en.wikipedia.org/wiki/X_Window_System), [Mac OS Toolbox](http://en.wikipedia.org/wiki/Macintosh_Toolbox) ([QuickDraw](http://en.wikipedia.org/wiki/QuickDraw)), and [Windows API](http://en.wikipedia.org/wiki/Windows_API) (Win16 API).  

With the Tk GUI toolkit, a novice programmer could create graphical programs in minutes and share it on numerous systems that supported Tcl/Tk. This included systems like many UNIX systems, Windows, Mac OS classic, Amiga OS, OS/2, and others.

Another popular tool called [Expect](http://en.wikipedia.org/wiki/Expect), created by Don Libes, that used TCL as its embedded language, gained popularity.  This tool allowed automating interactive command-line programs.

Apple even utilized TCL as the language for a test-harness called Curare, which tested modules that tested the network stack and imaging products. Apple also used TCL for scripting automation of microkernel modules in [NuKernel](http://en.wikipedia.org/wiki/Nukernel) before they embarked on buying [BeOS](http://en.wikipedia.org/wiki/BeOS) or [NeXTSTEP](http://en.wikipedia.org/wiki/NeXTSTEP) around 1996.

Gradually, popularity of TCL dwindled, perhaps due to increasing popularity of the Java platform, and rising popularity of web-client applications.  These technologies allowed sharing graphically applications that could run anywhere that Java or a web browser existed.  There were some tools created to integrate with these new technologies, such as [TclBlend](http://en.wikipedia.org/wiki/Tcl/Java), [Jacl](http://en.wikipedia.org/wiki/Tcl/Java) (TCL code that compiles to Java Bytecode), [TCL Plugin](http://www.tcl.tk/software/plugin/) (Netscape plug-in that allows running TCL in web pages).

Today, you can see TCL is used in niche solutions, such as Cisco networking equipement and F5 BigIP load balancers.

## Testing

* :dvd: *__OS X 10.8.5 (Mountain Lion)__*
  * :cd: tclsh 8.5 (bundled with operating system)

## Topics

### Part I

1. :books: Output
   * :green_book: Standard Output [A00]
   * :green_book: Standard Error [A10]
* :books: Variables
   * :green_book: String Interpolation [B10]
* :books: Arithmetic
   * :green_book: Basic Arithmetic [C00]
   * :green_book: Boolean Logic [C10]
   * :green_book: Exponential [C20]
   * :green_book: Math Function [C30]
* :books: Input
   * :green_book: Reading a Line [D00]
* :books: Branching
   * :green_book: Branch on Number Range [E20]
   * :green_book: Multiway Branch on String Pattern
     * :page_facing_up: ASCII Character Class [E50]
   * :green_book: Branch on String Pattern
     * :page_facing_up: ASCII Character Class [E60]
* :books: Looping
  * :green_book: Collection Loop [F00]
  * :green_book: Count Loop
    * :page_facing_up: Loop with general loop construct `for` [F10]
    * :page_facing_up: Loop with `while` [F11]
  * :green_book: Conditional Loop [F20]
  * :green_book: Spin Loop using `break` [F30]
  * :green_book: Skipping with `continue` [F40]
* :books: Arrays
  * :green_book: Assign by Index and Length [G00]
  * :green_book: Assign by List and Enumeration by Item [G10]
  * :green_book: Assign by List and Enumeration by Index [G20]
* :books: Associative Arrays
  * :green_book: Assign by Key [H00]
  * :green_book: Assign by List and Appending
    * :page_facing_up: Collection loop extracting key [H10]
    * :page_facing_up: Collection loop extracting key/value pairs [H11]

### Part II


* :books: Sub-Routines
  * :green_book: Creation and Calling [I00]
* :books: Arguments (Command Line)
  * :green_book: Usage Statement (Script Name and Arg Count) [J00]
  * :green_book: Enumerate Arguments in Order
    * :page_facing_up: Collection Loop [J10]
    * :page_facing_up: Count Style Loop [J11]
  * :green_book: Enumerate Arguments in Reverse Order
    * :page_facing_up: Count Style Loop  [J20]
* :books: Parameters (Sub-Routines)
  * :green_book: Pass a Single Parameters [K00]
  * :green_book: Pass Variable Number of Parameters [K10]
* :books: Exit
   * :green_book: Returning an Exit Status Code [L00]
* :books: Functions [M00]
   * :closed_book: Return an Integer [M00]
* :closed_book: Return a String [M10]
