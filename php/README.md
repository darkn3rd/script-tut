# Scripting Tutorial: PHP

© Joaquin Menchaca, 2014

## Overview

OVERVIEW

## Getting PHP: MAC OS X

On *Mac OS X 10.8.5*, a version of PHP comes built it, so you can begin using PHP scripts immediately.

## Getting PHP: Windows 7

On Windows NT systems, such as *Windows 7*, you can get PHP from http://windows.php.net/download/.  Download the ZIP file for the binaries.  The process to install PHP can be complex:

1. Create a directory where you want PHP to live, such as C:\PHP.  You can do this in command shell: ```MKDIR C:\PHP```
2. Download ZIP archive from http://windows.php.net/download/ in your favorite web browser.  On Windows 7, this drops the archive ```php-5.5.13-nts-Win32-VC11-x86.zip``` (assuming we downloaded PHP 5.5.13) into the ```%USERPROFILE\DOWNLOADS\``` directory.
3. Open the the downloaded archive using Windows Explorer or from Command Shell (assumes PHP 5.5.13): ```RUNDLL32.EXE ZIPFLDR.DLL,RouteTheCall %USERPROFILE%\DOWNLOADS\php-5.5.13-nts-Win32-VC11-x86.zip``` 
4. Copy the the contents in this window and paste them into a directory of your choice, such as C:\PHP.  From Command Shell, assuming we created ```C:\PHP```: ```EXPLORER C:\PHP```
5. Update the Search Path.  The easiest way is to use the Command Shell. Search for CMD.EXE, and right click on program and select "Run As Administrator", then type (assumes PHP lives in ```C:\PHP```): ```SETX /M PATH "%PATH%;C:\PHP"```.
6. Close Command Shell windows, as this will not pick up the new path.
7. PHP will not work, as it needs the ```MSVCR1110.DLL```, which is the C++ Runtime library (32-bit).  You'll need to install this, which currently (June 2014), can be found at http://www.microsoft.com/en-us/download/details.aspx?id=30679.  Select the 32-bit version or ```VSU_4\vcredist_x86.exe```.  Run the executable follow through the install wizard and license agreement.
8. Now everything should be ready, open up a new command shell, and type: ```php -v``` and something should be printed, such as: 
```
PHP 5.5.13 (cli) (built: May 28 2014 09:48:23)
Copyright (c) 1997-2014 The PHP Group
Zend Engine v2.5.0, Copyright (c) 1998-2014 Zend Technologies
```
9. (optional) In order to run scripts in the command shell by simply typing your script's filename, where your script's filename has a ```.php``` extension, you'll need to associate the .php extension with the PHP program.  This can be done on Windows 7 by first opening ```CMD.EXE``` as Administrator (search for ```CMD.EXE```, and right-click, select *Run As Administrator*), and then typing these commands (again assuming PHP lives in ```C:\PHP```).
```
assoc .php=phpfile
ftype phpfile="C:\PHP\php.exe" -f "%1" -- %~2
```
10. (optional) If you are using Git Bash (which is Mingw UNIX tools bundled with msysgit from http://msysgit.github.io/), you can run the following command to create virtual symbolic link to PHP program (again assumes PHP is in ```C:\PHP```): ```ln -s /c/php/php.exe /usr/bin/php```.  The PHP scripts will not need to have the ```.php``` extension, but will need to now have ```#!/usr/bin/php``` as the first line of the script.  If the script has this and the ```.php``` extension, it will run in Git Bash or command shell.

## How It Works

The PHP utilized here is the PHP-CLI, which means you can use this on the command-line.  The major difference is simply that the output is just raw text strings, rather that markup language.  

In my experience, PHP predominantly popular as language for developing websites, either just for doing a proof-of-concept project and then using another platform, or as the main technology and using other engines to increase performance.

For system administration oriented scripting, PHP has been used in niche products, such as FreeNAS and m0n0wall from what I have heard.  

To use PHP in command-line mode, nothing is needed, and the only tags required are the ```<?php``` and ```?>``` and the beginning and the end, with your code in the middle.  

## Testing

* Mac OS X 10.8.5, PHP 5.3.26
* Windows NT 6.1 (Windows 7), PHP 5.5.13 (http://windows.php.net/download/)

## Topics with Details 

This covers notes regarding each section.

1. **Output**
2. **Variables**
   * output variables using string concatenation using concatenation operator ```.```
   * output variables using string interpolation.
3. **Arithmetic**
4. **Input**
5. **Branch**
   * select on number using ```if```
   * select on character using ```switch```
     * **NOTES** 
       * *PHP cannot do pattern matching in scripts, so creative alternative utilized*
       * *POSIX selectors for internationalization are fully supported in PHP*
   * select on character using ```if```
     * **NOTE** * *POSIX selectors for internationalization are fully supported in PHP*
6. **Looping**
   * iterative (count) loop
     * alternative shows conditional loop with counter illustrated
   * conditional loop
   * collection loop
7. **Arrays**
   * populate array using index
   * populate array using list of items
   * enumerate array using collection loop
8. **Associative Arrays**
   * Create Associative Array using key index
   * Create Associative Array using supplied list of key and value pairs
9. **Subroutines** 
   * utilize subroutine that prints the current date in "Month Day, Year" format
10. **Arguments**
    * demonstrate testing for two arguments
    * print list of all arguments with count
    * print list of all arguments in reverse with count
11. **Parameters**
   * demonstrate passing 1 parameter
     * utilize subroutine that prints celsius temperature when supplied fahrenheit temperature
   * demonstrate passing unlimited parameters
12. **Functions**
    * demonstrate returning integer
      * returns summation of all numbers passed into function 
    * demonstrate returning string
      * returns capitalized string from lower case string 
