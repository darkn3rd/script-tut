# Scripting Tutorial: VBScript (WSH)

© Joaquin Menchaca, 2014

## Overview

This area covers VBScript, a language supported by the *Active Scripting* platform embedded into *WSH (Windows Script Host)* (http://en.wikipedia.org/wiki/Windows_Script_Host).  This environment provides access to a plethora of object libraries on Windows through a mechanism called *OLE Automation*.  

The WSH environment added desperated needed scripting tools for the Windows environment, both Windows 4 (Windows '95) and Windows NT, where before there was only *BATCH* and *Command Shell* (http://en.wikipedia.org/wiki/Batch_file), or inconsistent (non-ubiquitious) usage of third party scripting tools.

The WSH environment has been integrated since Windows 2000.  There's an installer for WSH 5.7 for earlier versions of Windows.  The version 5.8 of WSH is integrated into more recent versions of Windows: Windows 7, Windows 8, Windows 2008, Windows 2012.

## Active Scripting Environment

Microsoft released modular scripting platform referred to as *Active Scripting* (http://en.wikipedia.org/wiki/Active_Scripting) in 1996, which can host a variety of scripting langauges, such as VBScript and JScript from Microsoft, and PerlScript from ActiveState.  This *Active Scripting* platform could then be embedded into other applications, such as IE (Internet Explorer), IIS (Internet Information Services) ASP (Active Server Pages), and WSH (Windows Script Host).  IE with the bundled *Active Scripting* platform was then embedded in a variety of software that desired to render web pages, such as WMP (Windows Media Player), Outlook, Outlook Express, Messenger, MSN Messenger, Windows Help, Windows Explorer, etc.

As many might realize that those programs mentioned above have been known for spreading viruses and malicious software.  The inate ability of *OLE Automation*, or the ability to access numerous object libraries on Windows, from a script is both a rich feature for applicaitons, but also problem.

These type fo scripts can can provide backdoor access into a system.  A client program that connects to servers on the Internet and runs scripts from such a server on the client system, can potentialy be dangerous.  Thus a program like a web browser (Internet Explorer) or a mail client (Outlook) that uses such a feature is dangerous.

## Testing

* Windows 7, WSH 5.8

## Notes 

This covers notes regarding each section.

1. Output
2. Variables
   * escaping characteres with quote ```"``` character
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
   * interative (count) loop
     * ```for ... step ... next``` construction
     * ```while ... wend``` contruction
   * conditional loop
     * ```do ... loop until ( ... )``` contruction
     * ```do ... loop while ( ... )``` construction
     * ```do until ( ... ) ... loop``` construction 
   * collection loop
     * ```for each ... in ... next``` construction
     * added helper function ```exec``` to run commands and return an array of strings for the output
7. Arrays
   * populate array using index
   * enumerate array using collection loop
   * enumerate array using interative loop
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
     * utilize subroutine that prints celius temperature when supplied fahrenheit temperature
   * demonstrate passing unlimited parameters
     * *Note* VBscript does not support unlimited parameters.  Alternative is to create an temporary ```Array``` and pass the array.
     * utilize subroutine prints sum of all numbers passed into it.
12. Functions
    * demonstrate returning integer
      * returns summartion of all numbers passed into function 
    * demonstrate returning string
      * returns capitalized string from lower case string 
