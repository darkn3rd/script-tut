#!/bin/bash
# Switches which cscript.exe/wscript.exe a bare "wine cscript"/"wine
#  wscript" resolves to, by swapping which file sits at system32.
#
# DllOverrides registry entries ("native,builtin" for jscript/vbscript/
#  scrrun/cscript.exe/wscript.exe) were tried first and confirmed NOT
#  sufficient for this - tested directly two ways (`wine reg add`, and a
#  regedit.exe /S import exactly matching winetricks' own w_override_dlls
#  mechanism) - neither changed bare invocation behavior at all. Only the
#  actual file present at system32 determines which engine runs, so
#  that's what this script actually swaps.
#
# - "builtin" (the default): Wine's own reimplementation, no extra
#   install needed - JScript/VBScript report themselves as ~5.8.x, no
#   host startup banner.
# - "native": a genuine Microsoft WSH 5.7 install, if you have one under
#   syswow64 (via `winetricks wsh57`) - JScript/VBScript report
#   themselves as 5.7.x, and cscript.exe prints its real startup banner.
#
# This copies files into system32, replacing whichever is there - an
#  explicit, deliberate, reversible action, never done automatically by
#  the test harness itself (WineShellScript in testbox/Script.rb always
#  uses whatever is at system32 uniformly, with no detection of its own).
#  Explicitly invoking "C:\windows\syswow64\cscript.exe" directly always
#  works regardless of this setting, since that file is never touched.
#
# Usage:
#   wsh_engine.sh builtin   # switch to Wine's own engine (the default)
#   wsh_engine.sh native    # switch to the real installed WSH 5.7
#   wsh_engine.sh status    # show which one is currently active

set -e

WINE_APP_STUBS="/Applications/Wine Stable.app/Contents/Resources/wine/lib/wine/x86_64-windows"
SYS32="$HOME/.wine/drive_c/windows/system32"
SYSWOW64="$HOME/.wine/drive_c/windows/syswow64"

case "$1" in
  builtin)
    cp "${WINE_APP_STUBS}/cscript.exe" "${SYS32}/cscript.exe"
    cp "${WINE_APP_STUBS}/wscript.exe" "${SYS32}/wscript.exe"
    echo "Now using Wine's own builtin WSH engine (JScript/VBScript ~5.8.x)."
    ;;
  native)
    if [ ! -f "${SYSWOW64}/cscript.exe" ]; then
      echo "No native WSH install found at ${SYSWOW64}/cscript.exe - run 'winetricks wsh57' first." >&2
      exit 1
    fi
    cp "${SYSWOW64}/cscript.exe" "${SYS32}/cscript.exe"
    cp "${SYSWOW64}/wscript.exe" "${SYS32}/wscript.exe"
    echo "Now using the real installed WSH 5.7 (JScript/VBScript 5.7.x)."
    ;;
  status)
    stub_sum=$(shasum -a 256 "${WINE_APP_STUBS}/cscript.exe" 2>/dev/null | cut -d' ' -f1)
    current_sum=$(shasum -a 256 "${SYS32}/cscript.exe" 2>/dev/null | cut -d' ' -f1)
    if [ "$stub_sum" = "$current_sum" ]; then
      echo "Wine's own builtin WSH engine is active (the default)."
    else
      echo "A non-default cscript.exe is active at ${SYS32}/cscript.exe - likely the native WSH 5.7 install."
    fi
    ;;
  *)
    echo "usage: $0 {builtin|native|status}" >&2
    exit 1
    ;;
esac
