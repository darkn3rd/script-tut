# Scripting Tutorial: Python

Version 1.6

© Joaquin Menchaca, 2014-2026

## Getting Python2

### Windows: Chocolatey

```bash
# Install Python2
choco install -y python2

# Make python2 resolve to Python 2
Copy-Item "C:\Python27\python.exe" "C:\Python27\python2.exe"
Copy-Item "C:\Python27\pythonw.exe" "C:\Python27\python2w.exe"

# If both Python2 and Python3 are installed, make sure `python` default is Python3
# Fix Path so that `python.exe` will always get Python3 (assuming Python3 is installed)
$sysPath = [Environment]::GetEnvironmentVariable("PATH", "Machine") -split ';' `
  | Where-Object { $_ -ne '' }
$python2Entries = $sysPath | Where-Object { $_ -like '*Python27*' }
$otherEntries   = $sysPath | Where-Object { $_ -notlike '*Python27*' }
$newPath = ($otherEntries + $python2Entries) -join ';'
[Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
```

#### Testing
* 📀 *__macOS 26.5 (Tahoe)__*
  * 📦 Python 2.7.18
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * **Shell**: PowerShell 5.1.26100.8875
    * 📦 Python 2.7.18
  * **Shell**: Command Shell (C:\Windows\System32\cmd.exe)
    * 📦 Python 2.7.18
* 📀 *__OS X 10.8.5 (Mountain Lion)__*
  * 💿 Python 2.7.2 (bundled with operating system)
* 📀 *__Cent OS 6.5__*

#### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install newer versions of Python and as well as other popular packages.  It uses existing Macintosh libraries and tools, and is by far the path of least resistance to get packages.  Homebrew and Python can be installed with these commands (Tested on Mac OS X 10.8.5):

`bash
Python -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile
brew install python
`

#### MacPorts

Mac Ports is a package management solution inspired from BSD ports.  MacPorts has the largest library of packages to date.  MacPorts works for all users, not just for only one developer on the system, and as such, making this more ideal if multiple users use the same system.  MacPorts installs latest tools and libraries as needed for the packages it installs.  This may be a good thing as Apple Mac OS X has extremely old versions of many tools that may have numerous bugs and security problems.

For MacPorts, you can install MacPorts on the desired target Mac OS X.  For example, for Mac OS X 10.8.5, you can do this:

```bash
curl -O https://distfiles.macports.org/MacPorts/MacPorts-2.3.0-10.8-MountainLion.pkg
sudo -S installer -verbose -pkg MacPorts-2.3.0-10.8-MountainLion.pkg -target /
```

After, you can update and install Python using something like this:

```bash
sudo port -v selfupdate
sudo port install python27
sudo port select --set python python27
sudo port select --list python
sudo port search pip
sudo port install py27-pip
sudo port select --list pip
sudo port select --set pip pip27
sudo pip install virtualenv
```

### Getting Python on Cent OS

* :dvd: *__Cent OS 6.5__*
  * :pacakge: Python 2.6.6 (default bundled with OS: `python --version`)

## Notes

This covers notes regarding each section.

1. Output
   * output text to standard out
   * output text to standard error
     * demonstrate Python 2.x: `print >>sys.stderr`
     * demonstrate: `sys.stderr.write`
   * output multi-line text using `"""`
2. Variables
   * output variables using string concatenation
   * output variables using string interpolation
     * demonstrate using `%` operator
     * demonstrate using `format()` method
   * output variables using explicit format specifiers
     * demonstrate using `format()` method (no f-strings in Python 2)
   * output multi-line text stored in a variable using `"""`
3. Arithmetic
   * show basic integer arithmetic
   * show basic boolean evaluation
   * show basic floating math with exponetial
   * show basic math function like cosine
4. Input
   * input a string
   * input a single character
5. Branch
   * test a string using `if`
   * test a string using ternary construction
   * test a number range
   * test a number for menu selection
   * multi-way test on a number for menu selection
     * **OMITTED**: *Python 2 has no `switch`/`match` statement (that's
       Python 3.10+), so there is no pure implementation of this lesson*
     * **ALTERNATIVE** `e41`: a `dict` keyed by value stands in for the
       multiway branch, the same idiom used by Perl for the same reason
   * multi-way test on single character with pattern matching
     * **OMITTED**: *Same limitation as above - no pure implementation*
     * **ALTERNATIVE** `e51`: a list of `(pattern, result)` pairs tested
       in order stands in for the multiway branch, since dict keys can't
       be regexes
   * test on single character with pattern matching
     * **NOTE** Utilized `python re.match(patter, string)` to simulate `=~`
     * **ALTERNATIVE** Using built-in Pythion `isdigit()`, `isupper()`, and `islower()`
6. Looping
   * collection loop with `for...in`
   * count style loop
     * demonstrate using `while`
     * demonstrate using collection loop and `range(times)`
     * demonstrate using collection loop and `reversed(range(times))`
     * demonstrate using collection loop and `range(start,downto,decrement)`
   * conditional loop
   * spin loop
   * spin loop with ability skip invalid input
7. Arrays
   * Array Initialization
      * initialize array by index
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
   * demonstrate subroutine referencing global variables
   * demonstrate subroutine explicitly using local variables
10. Arguments
    * demonstrate processing 2 arguments
      * **NOTES:** Python includes scriptname as first argument in `sys.argv`
    * demonstrate printing all arguments
      * use collection loop with list slice
      * use collection loop with `range()`
      * use count style loop using `while`
    * demonstrate printing arguments in reverse order
      * use count style loop using `while`
      * use collection loop with `range()`
      * use collection loop with list slice
11. Parameters
    * demonstrate passing a single parameter
    * demonstrate passing unlimited parameters
    * demonstrate swapping two variables passed in as parameters
      * **NOTE** Python does not have support for pass-by-reference, so we must package them up into a memory referenced datatype, so that the subroutine can swap them.
12. Exiting
    * demonstrate exiting with error code to communicate status
13. Functions
    * demonstrate function that returns an int
    * demonstrate function that returns a string
    * demonstrate function that returns an array
