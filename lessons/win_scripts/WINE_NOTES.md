# Experiments in WINE (WINE Is Not an Emulator)

WINE can run Win32 binaries on macOS, Linux, and other operating systems.  It comes bundled with the Command Shell (`cmd.exe`) and Windows Script Host (`cscript.exe`), as well as other utilities like `findstr.exe`, `where.exe`.

When you run a script such as BATCH file with `cmd.exe` or JScript or VBScript with `cscript.exe`, you cannot run non-Win32 binaries like `grep`.  If you would like to use those utilities, you'll have to install a Windows-native build of them somewhere on Wine's `PATH` (e.g. `$HOME/.wine/drive_c/windows/system32/`, or wherever an installer like Microsoft's Coreutils puts its own `bin/` directory - see below).

## Running WINE with Tests

### BATCH (`cmd.exe`)

#### Core Utils Tool

Microsoft provides Coreutils, a UNIX-style reimplementation of core utilities using the Rust language, for Windows. This will include `date.exe` and `grep.exe`

```bash
install_core_utils() {
  pushd ~/Downloads
curl -LO https://github.com/microsoft/coreutils/releases/download/v2026.6.16/coreutils-2026.6.16-x64.exe
  ACTUAL_SHA=$(shasum -a 256 coreutils-2026.6.16-x64.exe | cut -f1 -d' ')
  EXPECTED_SHA="f862b1aa433310420ae20f9b1384f3f974a26ba98ae37ac548061116a3ef6c62"

  if [ "$ACTUAL_SHA" != "$EXPECTED_SHA" ]; then
    echo "ERROR: CHECKSUM MISMATCH - DO NOT USE THIS FILE" >&2
    return 1
  fi

  echo "CHECKSUM OK"

  wine coreutils-2026.6.16-x64.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-

  if [ -z "$(find ~/.wine/drive_c -iname "date.exe" 2>/dev/null)" ]; then
    echo "ERROR: 'date.exe' was not installed" >&2
    return 1
  fi

  if [ -z "$(find ~/.wine/drive_c -iname "grep.exe" 2>/dev/null)" ]; then
    echo "ERROR: 'grep.exe' was not installed" >&2
    return 1
  fi

  popd
}

install_core_utils
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

The default Wine WSH5.8 environment fails and even causes a crash see [Wine builtin WSH (5.8.x) — failure summary](#wine-builtin-wsh-58x--failure-summary).  You can download WSH7 from Microsoft directly using [Winetricks](https://gitlab.winehq.org/wine/wine/-/wikis/Winetricks) ([source](https://github.com/winetricks/winetricks), [wiki](https://github.com/Winetricks/winetricks/wiki)).

```bash
brew install winetricks
winetricks wsh57
./wsh_engine.sh native
```

### Wine Server

If you run a Wine Server in the background, this will speed up executing any scripts. Without the server, running a small batch file will require bringing the whole translation stack every time a script is launched. 

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
wineserver -k
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

## Known Issue: Intermittent Empty Output on Test Invocations

Under this Wine-on-macOS setup, a small fraction of test invocations in the
`testbox` harness occasionally complete (no hang) but return empty or
truncated output instead of the expected text. It hits a different,
essentially random category each run (`E4`, `E6`, `D0`, `I0`, `J1`, `O0`,
`O2`, ... have all shown it at one point or another) and re-running the
exact same test in isolation immediately afterward typically passes. No
deterministic trigger has been found despite a fair amount of digging -
notably, it happens at a comparable rate with the harness's own
`WINE_DEBUG_HANG` diagnostic logging (see `testbox/Script.rb`'s
`debug_hang_log`) fully on or fully off, ruling out that logging itself as
the cause (confirmed via back-to-back full-suite runs with it unset).

Two related, real mechanisms *were* pinned down and fixed along the way,
though neither turned out to be the full explanation for this specific
symptom:

- **`wineboot.exe --init` doing real initialization work** right after a
  fresh `wineserver -p` starts (confirmed directly - seen consuming 60%+
  CPU immediately after a cold start). A real test invocation racing
  against this before it finishes was a source of multi-second slowdowns
  and, in the worst case, a full hang. Fixed with a synchronous, throwaway
  warm-up `wine` invocation in `WineShellScript.run_pre_actions!`, run once
  right after `wineserver -p` starts, absorbing that race before any real
  test ever runs.
- **Orphaned `winedevice.exe` processes holding a test's stdout pipe open**
  even after the direct `wine cmd` child process has already exited -
  confirmed directly via a `ps` snapshot taken mid-hang (no `wine cmd`
  child left, but `wineserver`/`winedevice.exe` still alive), causing
  Ruby's `Kernel#` to block forever waiting for an EOF that never comes.
  Fixed by routing every real test invocation through
  `shell_out_with_timeout` (25s) instead of a plain backtick, so this now
  fails as a bounded, visible `FAIL` instead of an indefinite hang
  requiring a manual `Ctrl-C`.

The residual "completes, but with less output than expected" symptom
documented here is a *different* manifestation of what looks like the same
underlying instability, and remains unresolved. It's currently treated as
expected environmental noise rather than chased further; a
retry-once-on-suspicious-empty-output policy for real test invocations was
considered but not implemented.

## Further Reading

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
