# Scripting Tutorial: VBScript (WSH)

© Joaquin Menchaca, 2014

## Overview

VBScript was added to the Microsoft products in 1996 through ActiveX Scripting Engine, or *Active Scripting* platform.  This component was integrated into Internet Explorer, along with JScript (JavaScript) to add robust scripting capabilities.  The same engine was integrated into Microsoft's web server called IIS, and was made able for scripting Windows through WSH (Windows Script Host), which is where these scripts will run.

VBScript owes its lineage to popular family of Microsoft BASIC language products, like QuickBASIC and later VisualBASIC.  A cousin of VBScript, called VBA (Visual Basic for Applications) was integrated into Microsoft Office, as a general-purpose Macro programing language.  The evolution of BASIC at Microsoft continues with the Microsoft .NET platform (VB.NET).  

These sets of scripts are for the WSH platform, as they provide automation for the Windows environment and command line input or console.

## Windows Script Host

VBScript, is one language supported by the *Active Scripting* platform (also called *ActiveX Scripting Engine*) embedded into *WSH (Windows Script Host)* (http://en.wikipedia.org/wiki/Windows_Script_Host).  This environment provides access to a plethora of object libraries on Windows through a mechanism called *OLE Automation*.  

The WSH environment added desperately needed scripting tools for the Windows environment, both Windows 4 (Windows '95) and Windows NT, where before there was only *BATCH* and *Command Shell* (http://en.wikipedia.org/wiki/Batch_file), or inconsistent (non-ubiquitous) usage of third party scripting tools.

The WSH environment has been integrated since Windows 2000.  There's an installer for WSH 5.7 for earlier versions of Windows.  The version 5.8 of WSH is integrated into more recent versions of Windows: Windows 7, Windows 8, Windows 2008, Windows 2012.  Unfortunately, WSH 5.8 is not available as an external installer for earlier Windows systems.

## Active Scripting Environment

Microsoft released modular scripting platform referred to as *Active Scripting* (http://en.wikipedia.org/wiki/Active_Scripting) in 1996, which can host a variety of scripting languages, such as VBScript and JScript from Microsoft, and PerlScript from ActiveState.  This *Active Scripting* platform could then be embedded into other applications, such as IE (Internet Explorer), IIS (Internet Information Services) ASP (Active Server Pages), and WSH (Windows Script Host).  IE with the bundled *Active Scripting* platform was then embedded in a variety of software that desired to render web pages, such as WMP (Windows Media Player), Outlook, Outlook Express, Messenger, MSN Messenger, Windows Help, Windows Explorer, etc.

As many might realize that those programs mentioned above have been known for spreading viruses and malicious software.  The innate ability of *OLE Automation*, or the ability to access numerous object libraries on Windows, from a script is both a rich feature for applications, but also problem when used for nefarious purposes.

This environment can can provide backdoor access into a system.  A client program that connects to servers on the Internet and runs scripts from such a server on the client system, can potentially be dangerous.  Thus a program like a web browser (Internet Explorer) or a mail client (Outlook) that uses such a feature is dangerous.


## Testing

These scripts have been testing on the following platforms.

* Windows 7, WSH 5.8
 
## Tools

* run - shell script for git bash used to run WSH scripts using cscript
* run.cmd - command shell script used to run WSH scripts using cscript

## Topics with Details 

This covers notes regarding each section.

1. Output
2. Variables
   * escaping characters with quote ```"``` character
3. Arithmetic
4. Input
   * *Note* Forced to do string concatenation, as interpolation not supported.
5. Branch
   * select on number using ```if```
   * select on character using ```case```
     * added helper function ```match``` to evaluate pattern and string and return true or false 
   * select on character using ```if```
     * added helper function ```match``` to evaluate pattern and string and return true or false  
6. Looping
   * iterative (count) loop
     * ```for ... step ... next``` construction
     * ```while ... wend``` construction
   * conditional loop
     * ```do ... loop until ( ... )``` construction
     * ```do ... loop while ( ... )``` construction
     * ```do until ( ... ) ... loop``` construction 
   * collection loop
     * ```for each ... in ... next``` construction
     * added helper function ```exec``` to run commands and return an array of strings for the output
7. Arrays
   * populate array using index
   * popular array using list of items
     * enumerate array using collection loop
     * enumerate array using iterative loop
8. Associative Arrays
   * *Note* OLE library ```Scripting.Dictionary``` utilized for this functionality as VBScript does not have native support.
     * Added helper function ```dictionary``` to accept arrays, ```Scripting.Dictionary``` limited to adding items only one item at a time.
     * Added helper function ```merge``` to allow merging an array to a ```Scripting.Dictionary``` object.
9. Subroutines
   * utilize subroutine that prints the current date in "Month Day, Year" format
10. Arguments
    * demonstrate testing for two arguments
    * print list of all arguments with count
    * print list of all arguments in reverse with count
11. Parameters
   * demonstrate passing 1 parameter
     * utilize subroutine that prints celsius temperature when supplied fahrenheit temperature
   * demonstrate passing unlimited parameters
     * *Note* VBScript does not support unlimited parameters.  Alternative is to create an temporary ```Array``` and pass the array.
     * utilize subroutine prints sum of all numbers passed into it.
12. Functions
    * demonstrate returning integer
      * returns summation of all numbers passed into function 
    * demonstrate returning string
      * returns capitalized string from lower case string 
