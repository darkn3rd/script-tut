# Scripting Tutorial: PHP

© Joaquin Menchaca, 2014

## Overview

OVERVIEW

## Getting PHP: MAC OS X

On *Mac OS X 10.8.5*, a version of PHP comes built it, so you can begin using PHP scripts immediately.

## Getting PHP: Windows 7

On Windows NT systems, such as *Windows 7*, you can get PHP from http://windows.php.net/download/.  Download the ZIP file for the binaries.  The process to install PHP can be complex:

* Create a directory where you want PHP to live, such as C:\PHP.  You can do this in command shell: 
```batch
MKDIR C:\PHP
```
* Download ZIP archive from http://windows.php.net/download/ in your favorite web browser.  On Windows 7, this drops the archive ```php-5.5.13-nts-Win32-VC11-x86.zip``` (assuming we downloaded PHP 5.5.13) into the ```%USERPROFILE\DOWNLOADS\``` directory.
```batch
start http://windows.php.net/downloads/releases/php-5.5.13-nts-Win32-VC11-x86.zip
```
* Open the the downloaded archive using Windows Explorer or from Command Shell (assumes PHP 5.5.13): 
```batch
RUNDLL32.EXE ZIPFLDR.DLL,RouteTheCall %USERPROFILE%\DOWNLOADS\php-5.5.13-nts-Win32-VC11-x86.zip
``` 
* Copy the the contents in this window and paste them into a directory of your choice, such as C:\PHP.  From Command Shell, assuming we created ```C:\PHP```: 
```batch
EXPLORER C:\PHP
```
* Update the Search Path.  The easiest way is to use the Command Shell. Search for CMD.EXE, and right click on program and select "Run As Administrator", then type (assumes PHP lives in ```C:\PHP```): 
```batch
SETX /M PATH "%PATH%;C:\PHP"
```
* Close Command Shell windows, as the new search patch will not be picked up in the current command shell.
```batch
exit
````
* PHP will not work, as it needs the ```MSVCR1110.DLL```, which is the Visual C++ 2012 Update 4 Runtime library (32-bit).  You'll need to install this, which currently (June 2014), can be found at http://www.microsoft.com/en-us/download/details.aspx?id=30679.  Select the 32-bit version or ```VSU_4\vcredist_x86.exe```.  Run the executable follow through the install wizard and license agreement.
```batch
start http://www.microsoft.com/en-us/download/details.aspx?id=30679
```
* Now everything should be ready, open up a new command shell, and type: ```php -v``` and something should be printed, such as: 
```
PHP 5.5.13 (cli) (built: May 28 2014 09:48:23)
Copyright (c) 1997-2014 The PHP Group
Zend Engine v2.5.0, Copyright (c) 1998-2014 Zend Technologies
```
* (optional) In order to run scripts in the command shell by simply typing your script's filename, where your script's filename has a ```.php``` extension, you'll need to associate the .php extension with the PHP program.  This can be done on Windows 7 by first opening ```CMD.EXE``` as Administrator (search for ```CMD.EXE```, and right-click, select *Run As Administrator*), and then typing these commands (again assuming PHP lives in ```C:\PHP```).
```batch
assoc .php=phpfile
ftype phpfile="C:\PHP\php.exe" -f "%1" -- %~2
```
* (optional) If you are using Git Bash (which has Mingw UNIX tools bundled with msysgit from http://msysgit.github.io/) and have followed the step above, you can run PHP scripts in Git Bash as well.  You'll need to create symlink to where PHP lives (again assumes PHP is in ```C:\PHP```), but running this in Git Bash: 
```bash
ln -s /c/php/php.exe /usr/bin/php
```
Running PHP scripts in Git Bash will **NOT** require the filename to have the ```.php``` extension, but will need the typical *shebang* line:
```bash
#!/usr/bin/php
``` 
If the script has the *shebang* and the ```.php``` extension, then it will run in both Git Bash or command shell.

## Testing

* Mac OS X 10.8.5, PHP 5.3.26 (default)
* Windows NT 6.1 (Windows 7 SP1 64-bit), MSVCR 11.00.51106.1, PHP 5.5.13 (http://windows.php.net/download/)

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
