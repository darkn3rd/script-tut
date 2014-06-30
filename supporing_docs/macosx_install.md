# Mac OS X Base State

This is the base state of Mac OS X for installations.

## Mac OS X 10.8.5 Moutain Lion 

Note this is valid as of June 2014.  After this date, the files and versions referenced may be obsolete.

### Base Mac OS X Installation

* Requirements: Macintosh running a version of Mountain Lion
  * Tested System:
    * Macbook Pro (2.8GHz Intel Core i, 16GB 1.6GHz DDR3 Mem) 
    * Mac OS X 10.8.3

#### Get Java

Install a version of Java from Apple on the system.  Maybe this might be updated with further updates.  This installs Java JDK 6.

1. Download Java: http://support.apple.com/downloads/DL1572/en_US/JavaForOSX2014-001.dmg
2. Mount the image: ```hdiutil mount $HOME/Downloads/JavaForOSX2014-001.dmg```
3. Install the package: ```sudo -S installer -verbose -pkg "/Volumes/Java for OS X 2014-001/JavaForOSX.pkg" -target /```
4. Test Results: ```java -version```
5. Umount the volume: ```hdiutil unmount "/Volumes/Java for OS X 2014-001"```

When testing using ```java --version```, the results should look like this:
```bash
java version "1.6.0_65"
Java(TM) SE Runtime Environment (build 1.6.0_65-b14-466.1-11M4716)
Java HotSpot(TM) 64-Bit Server VM (build 20.65-b04-466.1, mixed mode)
```

#### Update to Mac OS X 10.8.5

This will bring Mac OS X 10.8.x up to the latest version as of June 2014.  If you are already on Mac OS X 10.8.5, then this step can be skipped.

1. Get Mac OS X 10.8.5 Combo Update: http://support.apple.com/downloads/DL1676/en_US/OSXUpdCombo10.8.5.dmg
2. Mount the image: ```hdiutil mount $HOME/Downloads/OSXUpdCombo10.8.5.dmg```
3. Install the package: ```sudo -S installer -verbose -pkg "/Volumes/OS X 10.8.5 Update Combo/OSXUpdCombo10.8.5.pkg" -target /```
4. Restart the computer: ```osascript -e 'tell app "System Events" to restart'```

#### Install XCode 5.1.1

1. Get Xcode 5.1.1 from https://developer.apple.com/downloads/
2. Mount the image: ```hdiutil mount $HOME/Downloads/xcode_5.1.1.dmg```
3. Install Xcode application: ```sudo cp -R "/Volumes/Xcode/Xcode.app" /Applications```
4. Agree to License: ```sudo xcodebuild -license```
5. Test Results: ```/Applications/Xcode.app/Contents/Developer/usr/bin/gcc --version```

#### Install XCode Command Line Tools

1. Get Most recent Command Line Tools, which should be April 2014 from https://developer.apple.com/downloads/
2. Mount downloaded image: ```hdiutil mount $HOME/Downloads/command_line_tools_for_osx_mountain_lion_april_2014.dmg```
3. Install the package: ```sudo -S installer -verbose -pkg "/Volumes/Command Line Tools (Mountain Lion)/Command Line Tools (Mountain Lion).mpkg" -target /```
4. Umount the Xcode volume: ```hdiutil unmount /Volumes/Xcode```
5. Umount command line tools volume: ```hdiutil unmount "/Volumes/Command Line Tools (Mountain Lion)"```
6. Test command line tools: ```/usr/bin/gcc --version```

When testing the ```gcc --version```, we should see output similar to this: 
```make
Configured with: --prefix=/Applications/Xcode.app/Contents/Developer/usr --with-gxx-include-dir=/usr/include/c++/4.2.1
Apple LLVM version 5.1 (clang-503.0.40) (based on LLVM 3.4svn)
Target: x86_64-apple-darwin12.5.0
Thread model: posix
```

#### Post Installation 

From here, we can choose from a variety of sources to install packages.  The two tested here are Mac Ports (https://www.macports.org/) and Homebrew (http://brew.sh/).  Alternatively, you can install your own directly from source as well.  For anything using Java, you'll need to get this from Oracle.
