# Scripting Tutorial: PowerShell

© Joaquin Menchaca, 2014

Version 1.4

## Overview

Powershell is Microsoft's new platform for scripting and automating Windows system.  It's an environment that runs on top of the .NET platform, and has access to the wealth of .NET libraries.  There's a built-in mechanism to access OLE libraries as well, so in that sense it can easily replace the limited WSH (Windows Script Host) environment that hosted JScript and VBScript amongst other languages for scripting chores.

Powershell 2.0 is supported on Windows as early as Windows NT 5.1 (Windows XP) and Windows NT 5.2 (Windows 2003).  PowerShell 3.0 is supported on Windows NT 6.1 (Windows 7, Windows Server 2008 R2) and later.  PowerShell 4.0 is supported on Windows NT 6.2 (Windows 8 and Windows 2012) and Windows NT 6.1 with SP1 for their perspective releases. Future versions obviously will follow this pattern, and thus you'll need to get the latest Windows for the latest PowerShell.  Earlier versions of Windows do not support PowerShell officially (yes...there have been hacks), and so WSH and the traditional command shell (BATCH) may be the only options from Microsoft, but then those systems are EOL (End-of-Life) by Microsoft, and so most in the community may not even take notice.

Amongst the operating system from Microsoft, various interfaces, such as installing Features and Roles on Windows releases differ, and thus, there is limited consistent interfaces amongst different versions of Windows.  Thus scripts may need to check for the operating system and use the appropriate available APIs if the scripts needs to run on different versions of Windows.  This was a similar problem with earlier versions of Windows and popular tools, as they differed in availability, licensing, and command line switches.  Such is the problem today as it was before in the past.

## Getting PowerShell on Windows 7

PowerShell 2.0 comes bundled in Windows 7 in both 64-bit and 32-bit versions.  This program will run using the CLR Virtual Machine from the  using from the .NET 2.0 framework.  The default framework can be overridden or changed.

By default, PowerShell will not execute scripts unless you change the Execution Policy, which is simply a key stored in the registry.  You have to run ```Set-ExecutionPolicy RemoteSigned``` in PowerShell to modify this setting.  This will need to be done in both 32-bit and 64-bit versions to avoid any weirdness, as PowerShell scripts could get executed in either environment.

Any administrative chores will likely require escalated privileges.  To run PowerShell with these privileges, you will need to do the following:

1. Type PowerShell in the Start menu's Run field.
2. For either *Windows PowerShell* (64-bit) or *Windows PowerShell (x86)* (32-bit), you need to right-click on the program.
3. Select *Run As Administrator*.
4. In the dialog titled *User Account Control* that appears, click *Yes*. 

## Getting PowerShell on Mac OS X, Linux, and Unix

There is an open source equivalent to PowerShell called Pash.  The prerequisite for this is an installation of Mono, as Mono provides the CLR virtual machine and library support to run .NET applications.

* Pash: https://github.com/Pash-Project/Pash
* Mono: http://www.mono-project.com/

## Testing

* Windows NT 6.1 (Windows 7), PowerShell 2.0 (.NET 2.0)
```batch
C:\>powershell "get-host | select Version | ft -hide"

2.0
C:\>powershell "$PSVersionTable" | grep CLRVersion
CLRVersion                     2.0.50727.5477
```

* Mac OS X 10.8.5 (Mountain Lion), Pash (Mono 3.4.0 MDK)

```bash
$ mono --version | head -1
Mono JIT compiler version 3.4.0 ((no/d4511ef Tue Mar 25 14:35:52 EDT 2014)
$ mono Pash.exe "get-host" | grep Version | cut -d: -f2 | tr -d ' '
1.0.0.0
```

## Topics with Details 

This covers notes regarding each section.

1. Output
   * output text to standard out
     * ```Write-Host```
     * ```Write-Output```
     * naked string (last string is always ends up in standard output)
   * output text to standard error
     * ```Console]::Error.WriteLine()```
2. Variables
   * output variables using string interpolation
     * demonstrate using ```Set-Variable```
     * demonstrate using ```=``` operator
3. Arithmetic
   * show basic integer arithmetic
   * show basic boolean evaluation
   * show basic floating math with exponential
   * show basic math function like cosine
4. Input
   * input a string
     * demonstrate using ```Read-Host```
5. Branch
   * test a number range
   * multi-way test on single character with pattern matching 
   * test on single character with pattern matching
6. Looping
   * collection loops on directory listing and ```PsIsContainer``` to test for a directory
     * demonstrate using ```foreach()``` collection loop
     * demonstrate piping into ```ForEach-Object``` collection loop
     * demonstrate using ```switch``` to process the collection
   * count style loop
     * demonstrate using range operation ```..``` piped into ```foreach``` 
     * demonstrate using ```foreach``` with a range operation ```..```
     * demonstrate using general ```for``` looping construct 
     * demonstrate using ```while``` looping construct
   * conditional loop
     * demonstrate using ```do...while()``` loop construct
     * demonstrate using ```do...until()``` loop construct
     * demonstrate using ```while()``` loop construct
   * spin loop
     * demonstrate using ```do...while(1)``` with ```break``` to exit loop
   * spin loop with ability to skip invalid input
     * demonstrate using ```do...while(1)``` with ```continue``` to skipp to next iteration
7. Arrays
   * Array Initialization
      * initialize array one element at a time
        * demonstrate using concatenation operator ```+``` to append an element to an array
      * array length with ```length`` property
      * enumerate all elements
   * Array Enumeration 
      * declare and initialize array
      * enumerate array one element at a time
        *  demonstrate using collection loop with ```foreach```
      * enumerate array with an index
        *  demonstrate using general ```for``` to increment the index
8. Associative Arrays
   * Associative Array Initialization
      * initialize associative array by key
      * enumerate all keys
      * enumerate all values
   * Associative Array Enumeration
      * declare and initialize associative array
      * merge two associative arrays
      * enumerate associative array by key
        *  demonstrate using collection loop with ```foreach```
9. Subroutines
   * demonstrate declaring and calling subroutine
     *  demonstrate showing formatted date with ```Get-Date -UFormat```
10. Arguments
    * demonstrate processing 2 arguments
      * **NOTES:** Retrieving the script name can be done using ```$MyInvocation.MyCommand.Name```
    * demonstrate printing all arguments
      * use collection loop ```foreach```
      * use count style loop with ```for``` and a range built using ``..```
    * demonstrate printing arguments in reverse order
      * use count style loop with ```for``` and a range built using ``..```
11. Parameters
    * demonstrate passing a single parameter
      * demonstrate controlling degrees of significance with decimal numbers 
    * demonstrate passing unlimited parameters
12. Exiting
    * demonstrate exiting with error code to communicate status
13. Functions
    * demonstrate function that returns an int
    * demonstrate function that returns a string
      * string is capitalized using ```ToUpper()``` method




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