# Scripting Tutorial: VBScript (WSH)

© Joaquin Menchaca, 2014

## Overview

This area covers VBScript, a language supported by the *Active Scripting* platform embedded into *WSH (Windows Script Host)*.  This environment provides access to a plethora of object libraries on Windows through a mechanism called *OLE Automation*.  

The WSH environment added desperated needed scripting tools for the Windows environment, both Windows 4 (Windows '95) and Windows NT, where before there was only *BATCH* and *Command Shell*, or non-ubiquitious usage of third party scripting tools.  


## Active Scripting Environment

Microsoft released modular scripting platform referred to as *Active Scripting* in 1996, which can host a variety of scripting langauges, such as VBScript and JScript from Microsoft, and PerlScript from ActiveState.  This *Active Scripting* platform could then be embedded into other applications, such as IE (Internet Explorer), IIS (Internet Information Services) ASP (Active Scripting Pages), and WSH (Windows Script Host).  IE with the bundled *Active Scripting* platform was then bundled up and embedded in a variety of software that desired to render web pages, such as WMP (Windows Media Player), Outlook, Outlook Express, Messenger, MSN Messenger, Help, Windows Explorer, etc.

As many might deduce, many of these programs have been known for spreading viruses and malicious software.  The inate ability of *OLE Automation*, or the ability to access numerous object libraries on Windows, is both a rich feature for applicaitons, but also problem, as it can provide backdoor access into a system, especially a programs like a web browser or mail client.

## Notes 

This covers notes regarding each section.

1. Output
2. Variables
3. Arithmetic
4. Input
5. Branch
   * if on number
   * case on single character
     * **OMITTED**: *Python 2.x does not have switch/case construction* 
   * if on single character
     * *used* ```python re.compile(pattern).match(string)``` to simulate ```=~``` 
6. Looping
   * iterative loop 
      * example: 10 to 1
        * *while loop used for count down loop* 
   * conditional loops
   * collection loop
      * iterate through set of items 
      * example: directory listing
7. Arrays
   * Array Initialization
      * initialize array by index
        * *couldn't set element to string, used array of chars* 
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
   * Associative Array Enumeration
      * declare and initialize associative array
      * merge two associative arrays
      * enumerate associative array by key
9. Subroutines
   * demonstrate declaring and calling subroutine
10. Arguments
    * demonstrate processing 2 arguments
      * **Note:** *Python includes scriptname as first argument in ```sys.argv```*
    * demonstrate printing all arguments
      * **Note:** *Did not use shift as not available in Python 2.x, and impossible to shift elements when 1st is the script name* 
    * demonstrate printing arguments in reverse order
11. Parameters
    * demonstrate passing unlimited arguments
12. Functions
    * demonstrate function with return int
    * demonstrate function with return string

