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

Install a version of Java from Apple on the system.  Maybe this might be updated with further updates.

#### Update to Mac OS X 10.8.5

This installs the full update to bring Mac OS X upto to version 10.8.5


#### Install XCode 5.1.1 and XCode command line tools

1. Get Xcode 5.1.1 from https://developer.apple.com/downloads/
2. Mount downloaded image: ```hdiutil mount $HOME/Downloads/xcode_5.1.1.dmg```
3. Install Xcode: ```sudo cp -R "/Volumes/Xcode/Xcode.app" /Applications```
4. Agree to License: ```sudo xcodebuild -license```
5. Test Results: ```/Applications/Xcode.app/Contents/Developer/usr/bin/gcc --version```
6. Get Most recent Command Line Tools, which should be Aprile 2014 from https://developer.apple.com/downloads/
7. Mount downloaded image: ```hdiutil mount $HOME/Downloads/command_line_tools_for_osx_mountain_lion_april_2014.dmg```
8. Install the package: ```sudo -S installer -verbose -pkg "/Volumes/Command Line Tools (Mountain Lion)/Command Line Tools (Mountain Lion).mpkg" -target /```
9. Umount the Xcode volume: ```hdiutil unmount /Volumes/Xcode```
10. Umount command line tools volume: ```hdiutil unmount "/Volumes/Command Line Tools (Mountain Lion)"```
11. Test command line tools: ```/usr/bin/gcc --version```

When testing the gcc, we should see output similar to this: 
```bash
Configured with: --prefix=/Applications/Xcode.app/Contents/Developer/usr --with-gxx-include-dir=/usr/include/c++/4.2.1
Apple LLVM version 5.1 (clang-503.0.40) (based on LLVM 3.4svn)
Target: x86_64-apple-darwin12.5.0
Thread model: posix
```
