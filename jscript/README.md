# Scripting Tutorial: JScript (WSH)

© Joaquin Menchaca, 2014

Version 1.4

## Overview

This area covers JScript, Microsoft implementation of JavaScript during the *Browser Wars* days around 1996.  Microsoft JScript is a compatible language to ECMAScript standard, or ECMA-262.  Windows systems with WSH 5.6 installed are compatible ECMA-262 3rd Edition.  Later editions of WSH, such as WSH 5.8, which is bundled with Windows 7 and above will include new features such as RFC 4627 (JSON) and ES-CP (ECMA-327).

### Windows Script Host

JScript, is one language supported by the *Active Scripting* platform (also called *ActiveX Scripting Engine*) embedded into *WSH (Windows Script Host)* (http://en.wikipedia.org/wiki/Windows_Script_Host).  This environment provides access to a plethora of object libraries on Windows through a mechanism called *OLE Automation*.  

The WSH environment added desperately needed scripting tools for the Windows environment, both Windows 4 (Windows '95) and Windows NT, where before there was only *BATCH* and *Command Shell* (http://en.wikipedia.org/wiki/Batch_file), or inconsistent (non-ubiquitous) usage of third party scripting tools.

The WSH environment has been integrated since Windows 2000.  There's an installer for WSH 5.7 for earlier versions of Windows.  The version 5.8 of WSH is integrated into more recent versions of Windows: Windows 7, Windows 8, Windows 2008, Windows 2012.  Unfortunately, WSH 5.8 is not available as an external installer for earlier Windows systems.

### Active Scripting Environment

Microsoft released modular scripting platform referred to as *Active Scripting* (http://en.wikipedia.org/wiki/Active_Scripting) in 1996, which can host a variety of scripting languages, such as VBScript and JScript from Microsoft, and PerlScript from ActiveState.  This *Active Scripting* platform could then be embedded into other applications, such as IE (Internet Explorer), IIS (Internet Information Services) ASP (Active Server Pages), and WSH (Windows Script Host).  IE with the bundled *Active Scripting* platform was then embedded in a variety of software that desired to render web pages, such as WMP (Windows Media Player), Outlook, Outlook Express, Messenger, MSN Messenger, Windows Help, Windows Explorer, etc.

As many might realize that those programs mentioned above have been known for spreading viruses and malicious software.  The innate ability of *OLE Automation*, or the ability to access numerous object libraries on Windows, from a script is both a rich feature for applications, but also problem when used for nefarious purposes.

This environment can can provide backdoor access into a system.  A client program that connects to servers on the Internet and runs scripts from such a server on the client system, can potentially be dangerous.  Thus a program like a web browser (Internet Explorer) or a mail client (Outlook) that uses such a feature is dangerous.

## Testing

* Windows 7, WSH 5.8
 
## Tools

* run - shell script for git bash used to run WSH scripts using cscript
* run.cmd - command shell script used to run WSH scripts using cscript

## Topics with Details 

This covers notes regarding each section.

1. **Output**
2. **Variables**
   * escaping characters with quote ```\``` character
3. **Arithmetic**
4. **Input**
   * *Note* Forced to do string concatenation, as interpolation not supported.
5. **Branch**
   * select on number using ```if```
   * select on character using ```switch```
   * select on character using ```if```
6. **Looping**
   * iterative (count) loop
     * ```for ( ... ; ... ; ... ) { ... }``` construction
     * ```while (...) { ... }``` construction
   * conditional loop
     * ```do { ... } while ( ... )``` construction
     * ```while ( ... ) { ... }``` construction
   * collection loop
     * ```for ( ... in ... )``` construction
     * added helper function ```exec``` to run commands and return an array of strings for the output
     * **Note:** *JScript does not support true arrays, thus cannot enumerate a collection into a list.  At most returns the indexes, which we use to fetch the value.*
7. **Arrays**
   * populate array using index
     * **Note:** *JScript does not support true arrays, indexes are converted to strings and used as a key to index into a hash*
   * popular array using list of items
     * enumerate array using collection loop
       * **Note:** *JScript does not support true arrays, thus cannot enumerate a collection into a list.  At most returns the indexes, which we use to fetch the value.*
     * enumerate array using iterative loop
8. **Associative Arrays**
   * Create Associative Array using key value
     * Uses ```array["key"]=value``` syntax
   * Create Associative Array using supplied list
     * Uses ```array = { "key":value, "key":value }``` syntax
     * Added helper function ```merge``` to allow concatenation of arrays
9. **Subroutines** 
   * utilize subroutine that prints the current date in "Month Day, Year" format
   * **Note:** *JScript does not have native method to extract the name of the month, so this must be done manually*
     * example using a months lookup array
     * example adding ```getMonthName()``` method to ```Date``` class. (*Complex*)
10. Arguments (TBA)
    * demonstrate testing for two arguments
    * print list of all arguments with count
    * print list of all arguments in reverse with count
11. Parameters (TBA)
   * demonstrate passing 1 parameter
     * utilize subroutine that prints celsius temperature when supplied fahrenheit temperature
   * demonstrate passing unlimited parameters
     * *Note* VBscript does not support unlimited parameters.  Alternative is to create an temporary ```Array``` and pass the array.
     * utilize subroutine prints sum of all numbers passed into it.
12. Functions (TBA)
    * demonstrate returning integer
      * returns summation of all numbers passed into function 
    * demonstrate returning string
      * returns capitalized string from lower case string 
