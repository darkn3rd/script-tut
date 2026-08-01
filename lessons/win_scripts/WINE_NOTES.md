# Experiments in WINE (WINE Is Not an Emulator)

WINE can run Win32 binaries on macOS, Linux, and other operating systems.  It comes bundled with the Command Shell (`cmd.exe`) and Windows Script Host (`cscript.exe`), as well as other utilities like `findstr.exe`, `where.exe`.

When you run a script such as BATCH file with `cmd.exe` or JScript or VBScript with `cscript.exe`, you cannot run non-Win32 binaries like `grep`.  If you would like to use those utilities, you'll have to them into your `$HOME/.wine/drive_c/windows/system32/` path.

## Running WINE with Tests

### BATCH (`cmd.exe`)


#### Grep Tool 

You can install the `grep` command using the following commands:

```bash
# 1. Get the file's metadata, including GitHub's own independently-computed
#    checksum (the git blob sha - separate data channel from the raw
#    download itself, though both ultimately come from GitHub)
curl -s "https://api.github.com/repos/mbuilov/grep-windows/contents/grep-3.11-x64.exe" \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print('sha:', d['sha']); print('size:', d['size'])"
# sha: 6e5451337f046d1dede2f401e709f46d39b8a3ec
# size: 1003008

# 2. Download it
curl -fsSL -o grep-3.11-x64.exe \
  "https://raw.githubusercontent.com/mbuilov/grep-windows/master/grep-3.11-x64.exe"

# 3. Verify the checksum BEFORE trusting the file at all - git's own
#    blob-hashing algorithm (sha1 with a "blob <size>\0" prefix), not a
#    plain shasum, is what matches GitHub's "sha" field
test "$(git hash-object grep-3.11-x64.exe)" = "6e5451337f046d1dede2f401e709f46d39b8a3ec" \
  && echo "CHECKSUM OK" || echo "CHECKSUM MISMATCH - DO NOT USE THIS FILE"

# 4. Verify it's a real Windows binary too
file grep-3.11-x64.exe   # expect: PE32+ executable (console) x86-64, for MS Windows

# 5. Drop it into Wine's system32 (already on %PATH% inside Wine)
cp grep-3.11-x64.exe ~/.wine/drive_c/windows/system32/grep.exe

# 6. Test it - redirect to a FILE, not a pipe, to avoid Wine's
#    orphaned-child-process-holds-the-pipe-open hang we hit earlier
wine cmd //c "grep --version" > /tmp/out.txt 2>&1; cat /tmp/out.txt
```

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

The default Wine WSH5.8 environemnt fails and even causes a crash see [Wine builtin WSH (5.8.x) — failure summary](#wine-builtin-wsh-58x--failure-summary).  You can download WSH7 from Microsoft directly using [Winetricks](https://gitlab.winehq.org/wine/wine/-/wikis/Winetricks) ([source](https://github.com/winetricks/winetricks), [wiki](https://github.com/Winetricks/winetricks/wiki)).

```bash
brew install winetricks
winetricks wsh57
./wsh_engine.sh native
```

### Wine Server

If you run a Wine Server in the background, this will speed up executing any scripts. Without the server, running a small batch file will require bringing the whole tranlation stack every time a script is launched. 

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

## Wine builtin WSH (5.8.x) — failure summary

Both engines fail on the same broad categories (stdin, arguments, env vars),
but VBScript additionally crashes and has a few failures JScript didn't hit.
All failures are fixed under native WSH 5.7 (41/41 pass, no crashes).

### Failed in both JScript and VBScript
(all with empty actual output — the script produced nothing)

| ID | Test | Notes |
|---|---|---|
| A1 | Standard Error | `WScript.StdErr` output not captured |
| A2 | Here Document / Multiline Output | |
| D0 | Reading a Line | needs `WScript.StdIn.ReadLine` |
| E0–E6 | all branch/pattern-matching tests | all prompt via stdin first |
| F0 | Collection Loop | |
| F2–F4 | Conditional/Spin/Skip loops | all stdin-driven |
| J0 | Usage Statement | fails only when arg count is wrong (tests 1–2); test 3 (correct args) passes |
| O0 | Command-Line Flags | short-form flags (tests 1–3) fail empty; long-form (tests 4–10) pass |
| N2 | Setting Environment Variables | env var never actually gets set |

### JScript-only failures
- **H0** – Assign by Key (VBScript's `H0` passed)
- **L0** – only sub-test 1 (bad args) fails; sub-tests 2–3 pass
- **O1 / O2** – only the "no valid flag" sub-tests fail; the rest pass

### VBScript-only failures (worse than JScript)
- **I0** – Creation and Calling: date fields come back blank (`Today is .`) instead of just a formatting mismatch
- **J1** – Enumerate Arguments in Order: only the header line prints, all 12 argument items are silently dropped
- **L0** – all three sub-tests fail (JScript only failed sub-test 1)
- **O1 – Multiple Command-Line Flags: all 4 sub-tests crash Wine outright**
  (`page fault... in vbscript+0x24754`, `WineDbg attached`) — a real engine
  crash, not just wrong output; did not occur anywhere in the JScript run
- **O2** – only the "no valid flag" sub-tests (1–2) fail empty; the rest pass




## Fruther Reading

* [macOS Gatekeeper / Quarantine / XProtect](https://hacktricks.wiki/en/macos-hardening/macos-security-and-privilege-escalation/macos-security-protections/macos-gatekeeper.html)
* [Gatekeeper and runtime protection in macOS](https://support.apple.com/guide/security/gatekeeper-and-runtime-protection-sec5599b66df/web)
* [Removing support for --no-quarantine for casks](https://github.com/Homebrew/brew/issues/20755)
* [wine-stable (deprecated)](https://formulae.brew.sh/cask/wine-stable)
* [Wine Wiki: MacOS](https://gitlab.winehq.org/wine/wine/-/wikis/MacOS)
* [How to get a certificate, the process of code-signing & notarization of macOS binaries for distribution outside of the Apple App Store.](https://dennisbabkin.com/blog/?t=how-to-get-certificate-code-sign-notarize-macos-binaries-outside-apple-app-store#run_unsigned)
* https://github.com/winetricks/winetricks
* https://github.com/mbuilov/grep-windows
* https://github.com/microsoft/coreutils
* https://github.com/uutils/grep
* https://github.com/Whisky-App/Whisky
