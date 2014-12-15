# Scripting Tutorial: Python

Version 1.5

© Joaquin Menchaca, 2014


## Getting Python

### Getting Python on Mac

#### Prerequisites

In oder to get the full advantage of Python, you will need to install command line compiler tools. This process can vary significantly on Mac OS X.  MacPorts keeps some good instructions at http://guide.macports.org/#installing.xcode.  For Mac OS X 10.8.5 as of June 2014, you can get latest versions Xcode 5.1.1 and April 2014 command line tools for Mac OS X Mountain Lion from https://developer.apple.com/downloads/.  

This requires you to setup an account.  Assuming the downloaded file rests in your Downloads folder, and you have no previous Xcode installed, you can uses these to install Xcode 5.1.1

```bash
hdiutil mount $HOME/Downloads/xcode_5.1.1.dmg
sudo cp -R "/Volumes/Xcode/Xcode.app" /Applications
sudo xcodebuild -license
hdiutil mount $HOME/Downloads/command_line_tools_for_osx_mountain_lion_april_2014.dmg
sudo -S installer -verbose -pkg "/Volumes/Command Line Tools (Mountain Lion)/Command Line Tools (Mountain Lion).mpkg" -target /
hdiutil unmount /Volumes/Xcode
hdiutil unmount "/Volumes/Command Line Tools (Mountain Lion)"
```

#### Default

* :dvd: *__OS X 10.8.5 (Mountain Lion)__*
  * :cd: Python 2.7.2 (bundled with operating system)



#### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install newer versions of Python and as well as other popular packages.  It uses existing Macintosh libraries and tools, and is by far the path of least resistance to get packages.  Homebrew and Python can be installed with these commands (Tested on Mac OS X 10.8.5):

```bash
Python -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile
brew install python
```

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
     * demonstrate Python 2.x: ```print >>sys.stderr```
     * demonstrate: ```sys.stderr.write```
   * output multi-line text using ```"""```
2. Variables
   * output variables using string concatenation
   * output variables using string interpolation
     * demonstrate using ```%``` operator
     * demonstrate using ```format()``` method
3. Arithmetic
   * show basic integer arithmetic
   * show basic boolean evaluation
   * show basic floating math with exponetial
   * show basic math function like cosine
4. Input
   * input a string
   * input a single character
5. Branch
   * test a string using ```if```
   * test a string using ternary construction
   * test a number range
   * test a number for menu selection
   * multi-way test on a number for menu selection
     * **OMITTED**: *Python does not have a mechanism for this*
   * multi-way test on single character with pattern matching
     * **OMITTED**: *Python does not have a mechanism for this*
   * test on single character with pattern matching
     * **NOTE** Utilized ```python re.compile(pattern).match(string)``` to simulate ```=~```
6. Looping
   * collection loop with ```for...in```
   * count style loop
     * demonstrate using ```while```
     * demonstrate using collection loop and ```range(times)```
     * demonstrate using collection loop and ```reversed(range(times))```
     * demonstrate using collection loop and ```range(start,downto,decrement)```
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
      * **NOTES:** Python includes scriptname as first argument in ```sys.argv```
    * demonstrate printing all arguments
      * use collection loop with list slice
      * use collection loop with ```range()```
      * use count style loop using ```while```
    * demonstrate printing arguments in reverse order
      * use count style loop using ```while```
      * use collection loop with ```range()```
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
