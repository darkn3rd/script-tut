# Experiments in WINE

## macOS

### Gatekeeper

Gatekeeper on macOS is a built-in security feature that ensures only trusted software, signed and notarized by Apple or verified developers, runs on your Mac.  This can prevent open source software that you download from the Internet from running.

```bash
# disable GateKeeper (security risk)
sudo spctl --master-disable
# remove quaranteen attribute
xattr -d com.apple.quarantine /path/to/app 
```

### Install 

```bash
# install wine
brew install --cask wine-stable
# setup wine data
ln -s "/Applications/Wine Stable.app/Contents/Resources/wine/share/wine" /usr/local/share/wine
ln -s "/Applications/Wine Stable.app/Contents/Resources/wine/lib/wine" /usr/local/lib/wine
```

### Wine Server

If you run a Wine Server in the background, this will speed up executing any scripts. Without the server, running a small batch file will require bringing the whole emulator stack every time a script is launched. 

```bash
# Run Server
wineserver -p &
# Verify Process is running
ps aux | grep wineserver
```

### Running Scripts

```bash
# quiet noisy output when running scripts
export MVK_CONFIG_LOG_LEVEL=0
export WINEDEBUG=-all

# run batch file
cd lessons/win_scripts/batch/scripts
wine cmd /c a00.output.cmd

# run VBSCript 
cd lessons/win_scripts/wsh.vbscript/scripts
wine cscript //Nologo a00.output.vbs

# run JSscript
cd lessons/win_scripts/wsh.jscript/scripts
wine cscript //Nologo a00.output.js
```

### Stop Wine Server

If the Wine Server is no longer needed, you can run this:

```bash
winserver -k
```

### For a list of applications

```bash
ls "/Applications/Wine Stable.app/Contents/Resources/wine/lib/wine/x86_64-windows/" | grep '\.exe$' | column
```

## Fruther Reading

* [macOS Gatekeeper / Quarantine / XProtect](https://hacktricks.wiki/en/macos-hardening/macos-security-and-privilege-escalation/macos-security-protections/macos-gatekeeper.html)
* [Gatekeeper and runtime protection in macOS](https://support.apple.com/guide/security/gatekeeper-and-runtime-protection-sec5599b66df/web)
* [Removing support for --no-quarantine for casks](https://github.com/Homebrew/brew/issues/20755)
* [wine-stable (deprecated)](https://formulae.brew.sh/cask/wine-stable)
* [Wine Wiki: MacOS](https://gitlab.winehq.org/wine/wine/-/wikis/MacOS)
* [How to get a certificate, the process of code-signing & notarization of macOS binaries for distribution outside of the Apple App Store.](https://dennisbabkin.com/blog/?t=how-to-get-certificate-code-sign-notarize-macos-binaries-outside-apple-app-store#run_unsigned)