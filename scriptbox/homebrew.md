# ScriptBox: Homebrew Guide
©2014 Joaquin Menchaca

## Overview

This is an overview of how to install these packages on Mac OS X using Homebrew.  These have been tested on OS X 10.8.5 and OS X 10.9.5.

## Requirements

### XCode

Download the latest [XCode](https://developer.apple.com/xcode/), XCode command line tools, and optionally [Java for OS X](http://support.apple.com/kb/DL1572)

### Java JDK

Java JDK variety is required, as JRE only installs a plug-in.  Here's an example of installing JDK 1.8:

```bash
$ curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-macosx-x64.dmg > ~/Downloads/jdk-8u25-macosx-x64.dmg
$ hdiutil mount ~/Downloads/jdk-8u25-macosx-x64.dmg
$ sudo -S installer -verbose -pkg "/Volumes/JDK 8 Update 25/JDK 8 Update 25.pkg" -target /
$ java -version
java version "1.8.0_25"
Java(TM) SE Runtime Environment (build 1.8.0_25-b17)
Java HotSpot(TM) 64-Bit Server VM (build 25.25-b02, mixed mode)
```

### HomeBrew

Install [HomeBrew](http://brew.sh/) as the package manage:

```bash
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew update
$ brew doctor
```

## Installation of Packages

Instead of documenting every little piece, here's a list of instructions to install, configure, and verify the needed components:

### Tools

```Bash
$ brew install gnu-sed --with-default-names
$ sudo /usr/local/bin/sed -e '/\/usr\/local\/bin/d' -e '1i /usr/local/bin' -i /etc/paths
```

### Shells

```Bash
$ brew install dash
$ brew install bash
$ brew install tcsh
$ ln -sf /usr/local/bin/dash /usr/local/bin/sh

```

### Scripting Languages

```Bash
$ brew install gawk
$ brew install groovy
$ brew install perl
$ brew link --force perl
$ brew install zlib
$ brew install homebrew/php/php56
$ brew install python
$ pip install --upgrade --no-use-wheel pip
$ pip install virtualenv
$ pip install --upgrade --no-use-wheel setuptools
$ brew install ruby
$ gem update
$ gem install bundler
```

### Verification

```Bash
$ sed --version | head -1
sed (GNU sed) 4.2.2
$ bash --version | head -1
GNU bash, version 4.3.30(1)-release (x86_64-apple-darwin13.4.0)
$ ksh --version
version         sh (AT&T Research) 93u+ 2012-08-01
$ echo Debian Ash, version $(ls -l `which dash` | grep -o '\d\.\d\.\d')
Debian Ash, version 0.5.7
$ awk --version | head -1
GNU Awk 4.1.1, API: 1.1
$ groovy --version
Groovy Version: 2.3.7 JVM: 1.8.0_25 Vendor: Oracle Corporation OS: Mac OS X
$ perl --version | grep 'v[0-9]'
This is perl 5, version 20, subversion 1 (v5.20.1) built for darwin-thread-multi-2level
$ php --version | head -1
PHP 5.4.30 (cli) (built: Jul 29 2014 23:43:29)
$ pear version | head -1
PEAR Version: 1.9.5
$ python --version
Python 2.7.9
$ pip --version
pip 6.0.3 from /usr/local/lib/python2.7/site-packages (python 2.7)
$ ruby --version
ruby 2.1.5p273 (2014-11-13 revision 48405) [x86_64-darwin13.0]
$ gem --version
2.2.2
$ bundle --version
Bundler version 1.7.9
```

## Installing Windows Scripting Languages (Experimental)

### Windows Scripting Shell

In order to run WSH environment, you need ABI compatibility, which can be installed using [WINE](https://www.winehq.org/).  [WINE](https://www.winehq.org/) will require [XQuartz](http://xquartz.macosforge.org/landing/) application, which can be installed using the [Cask](http://caskroom.io/) package management system (which uses [Homebrew](http://brew.sh/)).

```Bash
brew install caskroom/cask/brew-cask
brew cask install xquartz
brew install wine
```

Note that [WINE](https://www.winehq.org/) has numerous dependencies: xz, libpng, freetype, jpeg, [libtool](http://www.gnu.org/software/libtool/), [libusb](http://www.libusb.org/), [libusb-compat](http://www.libusb.org/wiki/libusb-compat-0.1), [fontconfig](http://fontconfig.org), [libtiff](http://download.osgeo.org/libtiff/), gd, libgphoto2, little-cms2, jasper, libicns, makedepend, openssl, and sane-backends.

### PowerShell with Pash Project

There a group developing cross platform version of Powershell called Pash: https://github.com/Pash-Project/Pash.

Before installing, you'll need a CLI (Common Language Infrastructure) environment, such as that supported by either Microsoft.NET or Mono Project.  Mono can be installed with Homebrew.

```Bash
brew install mono
git clone https://github.com/Pash-Project/Pash.git
cd Pash
xbuild
echo 'mono ~/Pash/Source/PashConsole/bin/Debug/Pash.exe "$@"' > /usr/local/bin/pash
chmod +x /usr/local/bin/pash
```

After you can run your scripts by using something like: `pash yourscript.ps1`.  Note that this project is not completely mature, and only supports a limited set of functionality.  Though what it does support is promising.
