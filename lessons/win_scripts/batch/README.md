# Scripting Tutorial: BATCH (Command Shell)

© Joaquin Menchaca, 2014-2026

Version 1.2

## Overview

This covers the Windows Command Shell, sometimes referred to as BATCH due to the similarity with historical DOS operating system.  Windows Command Shell scripts will end with the ```.CMD``` extension, but the environment will also execute scripts with the ```.BAT``` extension as well.  The scripts in this section only work with Windows Command Shell found in flavors of [Windows NT](http://en.wikipedia.org/wiki/Windows_NT).

## History

The *BATCH* environment has existed since 1981 with the releases of [MS-DOS](http://en.wikipedia.org/wiki/MS-DOS), [IBM PC-DOS](http://en.wikipedia.org/wiki/IBM_PC_DOS), and [DR-DOS (Digital Research DOS)](http://en.wikipedia.org/wiki/DR-DOS). Different versions of [Windows 4.x](http://en.wikipedia.org/wiki/Windows_9x) were bundled with [MS-DOS](http://en.wikipedia.org/wiki/MS-DOS), and thus by nature included the the *BATCH* environment.

| OS Lineage            | Version        | Release Year | Distribution Bundle Status | Core Language, Shell, and Batch Extensions |
| :-------------------- | :-------------: | :-----------: | :--------------------------- | :--- |
| **PC DOS (IBM)**      | **1.0 - 3.3**  | 1981 - 1987  | OEM | Primitive base `COMMAND.COM` architecture and utilities: `MODE`, `FDISK`, `XCOPY`, and `DEBUG`<br>Available as standalone OS, or bundled with **OS/2 1.x** (16-bit PM) that ran PC-DOS code in an internal compatibility box (emulator). |
| **DR DOS (Digital Research)**<sup>1</sup> | **5.0** | 1990        | Retail | Introduced `ViewMAX` GUI. Advanced memory loading freed base RAM blocks for heavy batch structures. |
| **MS-DOS (Microsoft)** | **5.0**        | 1991         | Retail | `QBasic`, `EDIT` text editor, `DOSKEY` command-line macros. |
| **DR DOS**<sup>1</sup> | **6.0**        | 1991         | Retail | Integrated `TaskMAX` task switcher. Bundled `SuperStor` file compression hooks directly at the prompt. |
| **PC DOS**            | **5.0**  | 1992 - 1994  | **OS/2 2.x** | Bundled with **OS/2 2.x** (32-bit Core) that runs PC DOS in crash-proof MVDM virtual machines. |
| **Novell DOS**<sup>1</sup>        | **7.0**        | 1993         | Retail | Preemptive multitasking (`TASKMGR`), networking tools (`SCRIPT`), conditional execution syntax, and recursive `XDIR`. |
| **MS-DOS**            | **6.0 / 6.22** | 1993 - 1994  | Retail | Added the `CHOICE` command for custom user menus and conditional processing. |
| **PC DOS**            | **6.1 - 6.3**  | 1993 - 1994  | Retail | Independent fork splitting from Microsoft. Replaced standard text-parsing utilities with proprietary IBM equivalents. |
| **MS-DOS**            | **7.0**<sup>2</sup>        | 1995         | **Windows 95** (4.0) | **32-bit Pipeline Swapping:** Native Long File Names (LFN) and `START` execution thread management commands. |
| **PC DOS**            | **7.0**        | 1995         | Retail | Bundled the structural **REXX language interpreter**, stepping completely past primitive batch loop rules. |
| **MS-DOS**            | **7.1**<sup>2</sup>        | 1996         | **Windows 95 OSR2** (4.0)<br>**Windows 98** / **98 SE** (4.1) | **FAT32** file structure and LBA storage layout parsing. |
| **OpenDOS (Caldera)**<sup>1</sup> | **7.01**       | 1997         | OSS | Features advanced **4DOS** out-of-the-box as the highly customizable default system shell interpreter. |
| **DR-DOS (Caldera)**<sup>1</sup>  | **7.02 / 7.03**| 1998 - 1999  | Retail | Commercial cleanup of OpenDOS. Retained advanced **4DOS** macro syntax engine parsing. |
| **PC DOS**            | **2000**       | 1998         | Retail | Final physical retail version of IBM PC DOS. Resolved hard structural date handling and Y2K batch logic. |
| **MS-DOS**            | **8.0**<sup>2</sup>        | 2000         | **Windows ME** (4.9) | Restricted real-mode hook intercepts. Blocked traditional `AUTOEXEC.BAT` parsing to shorten desktop boot cycles. |
| **FreeDOS**           | **1.0**        | 2006         | OSS | Bundles **`FreeCOM`** as the default shell, adding native line editing, history logs, and tab completion. |
| **FreeDOS**           | **1.1 - 1.3**  | 2012 - 2022  | OSS | Package managers (`FDIMPLES`), HTML-based **`FDHELP`** reference documentation tool. |
| **FreeDOS**           | **1.4**        | 2025         | OSS | Modern `FreeCOM` shell string patches, native 7-Zip file compression layout logic. |

**NOTES**:
1. **Novell DOS** and **OpenDOS** are part of the same DR DOS family. 
2. These **MS-DOS** versions were not available separately and were bundled with Microsoft Windows.

A new environment, called *Command Shell*, was introduced with the with [IBM OS/2](http://en.wikipedia.org/wiki/OS/2), and later with [Microsoft Windows NT](http://en.wikipedia.org/wiki/Windows_NT).  Future versions of [Windows NT](http://en.wikipedia.org/wiki/Windows_NT), marketed as Windows XP, Windows 7, Windows 8, and so forth, continue to carry the *Command Shell*.

## Alternatives to Batch

The original BATCH environment was extremely limited, and was extended in a variety of ways.  

Historically in [MS-DOS](http://en.wikipedia.org/wiki/MS-DOS), popular alternatives documented in [DOSWorld](http://www.pcmuseum.ca/collections.asp?type=Magazine&group=DOS%20World) included compiling small Assembly language scripts using [`DEBUG`](http://en.wikipedia.org/wiki/Debug_%28command%29) and starting with [MS-DOS](http://en.wikipedia.org/wiki/MS-DOS) 5.0, one could write [QBasic](http://en.wikipedia.org/wiki/QBasic) scripts and run them using  `QBASIC /RUN`.  

In IBM's [PC-DOS](http://en.wikipedia.org/wiki/IBM_PC_DOS), IBM included the [REXX](http://en.wikipedia.org/wiki/Rexx) scripting environment, borrowed from their mainframe OSes.  The [REXX](http://en.wikipedia.org/wiki/Rexx) environment was popular on mainframes and and also the [Amiga OS](http://en.wikipedia.org/wiki/AmigaOS).  

A popular shareware application [4DOS](http://en.wikipedia.org/wiki/4DOS) was quite popular.  [MKS Toolkit](http://en.wikipedia.org/wiki/MKS_Toolkit), which provided [Korn Shell](http://en.wikipedia.org/wiki/Korn_shell) capability to DOS was a popular offering. The public domain toolset [DGJPP](http://www.delorie.com/djgpp/) provided UNIX compilers and tools to DOS.  

Today, Windows Command Shell has added features beyond its earlier BATCH cousin, but it is still quite limited.  For any heavy lifting, Microsoft has provided [WSH (Windows Scripting Host)](http://en.wikipedia.org/wiki/Windows_Script_Host) with support for languages like [VBScript](http://en.wikipedia.org/wiki/VBScript) and [JScript (JavaScript)](http://en.wikipedia.org/wiki/JScript) for scripting the environment.  Also popular were languages like Perl, Python, Ruby, and [KiXart](http://www.kixtart.org/).  Today, especially after Windows 2008, [PowerShell](http://en.wikipedia.org/wiki/Windows_PowerShell) has become the one ubiquitous language for modern Windows operating systems, but still the Command Shell remains popular for basic chores.

## Batch Usage

Despite many alternatives, BATCH is still used in system administration.  This is in part because the Command Shell, which implements the BATCH environment, is the default shell of Windows.  I have come across companies (2012) that use BATCH scripts for complex distributed [SaaS](http://en.wikipedia.org/wiki/Software_as_a_service) web application environments as part of change configuration automation and software deployment.  Some ported GNU tools, like `date` were used in conjunction with BATCH scripts.

Additionally, alternatives, such as WSH or PowerShell, are overly complex for simple automation chores.  PowerShell is layers abstracted from source, i.e. bytecode .NET application calling other bytecode .NET libraries that call OLE COM libraries, which in turn call original binary DLL libraries, which adds complexity and decreases performance.  Therefore, Windows Command Shell's BATCH may be the easiest path to automation.


## Testing

* 📀 *__Windows 7 Home__* (`Microsoft Windows NT [Version 6.1]`)
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * 🐚 PowerShell 5.1.26100.8875 (DotNet 4.0.30319.42000)
  * 🐚 Command Shell (cmd.exe)

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

### Links

* [SS64 Command line reference](http://ss64.com/nt/) - Awesome reference site for Command Shell and Windows commands.
* [Guide to Windows Batch Scripting](http://steve-jansen.github.io/guides/windows-batch-scripting/)

### Lessons Omitted

Command Shell (Batch) barely supports string variables, and certainly does not support ***arrays*** or ***associative arrays***.  

### Tidbits while Batching

* Special characters can be escaped with the carrot `^` character, and line continuations can be used with the carrot `^` placed at the end of the line.

* The original Batch never had the ability to do a sub shells and then capture output from commands executed in the sub shell.  Command Shell added this ability with the `for` loop.

* The BATCH equivalent of subroutines are accessed through `CALL` and end with `GOTO :EOF` and parameters can be passed into the subroutine.

* Some limited globbing can be performed with the external `FINDSTR` command, but like filenames, the tool cannot distinguish between lower case and upper case, so `[a-z]` is the same as `[A-Z]`.
