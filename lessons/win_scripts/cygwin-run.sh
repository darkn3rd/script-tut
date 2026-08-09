#!/usr/bin/env bash
set -euo pipefail

COMMAND_NAME=${0##*/}

case $COMMAND_NAME in
  cmd)     USAGE='cmd <path-to-script.cmd|.bat> [args...]' ;;
  cscript) USAGE='cscript <path-to-script.js|.vbs> [args...]' ;;
  *)       printf 'cygwin-run: invoke this script as cmd or cscript\n' >&2; exit 2 ;;
esac

if (( $# < 1 )); then
  printf 'Usage: %s\n' "$USAGE" >&2
  exit 2
fi

INPUT_PATH=$1; shift

if ! SCRIPT_PATH=$(realpath -e -- "$INPUT_PATH"); then
  printf '%s: cannot resolve file: %s\n' "$COMMAND_NAME" "$INPUT_PATH" >&2; exit 1
fi

if [[ ! -f $SCRIPT_PATH ]]; then
  printf '%s: not a regular file: %s\n' "$COMMAND_NAME" "$SCRIPT_PATH" >&2; exit 1
fi

# Unlike wsl1-run.sh, cmd.exe already inherits a genuine native Windows cwd
# from Cygwin bash here - confirmed directly, a bare relative filename with
# no path prefix at all runs fine. The actual problem is narrower: Cygwin's
# own argv handling mis-parses a "./"-style relative path passed as an
# argument to a native (non-Cygwin) executable - confirmed directly,
# "cmd /c ./scripts/a00.output.cmd" fails with "'.' is not recognized...",
# while the identical file referenced by its Windows form
# ("cmd /c \"$(cygpath -w ./scripts/a00.output.cmd)\"") runs fine. Resolving
# to a real Windows path here sidesteps that entirely, the same fix
# `cygpath -w` already gets used for.
WIN_PATH=$(cygpath -w "$SCRIPT_PATH")

case $COMMAND_NAME in
    cmd)     exec cmd.exe /c "$WIN_PATH" "$@" ;;
    cscript) exec cscript.exe //Nologo "$WIN_PATH" "$@" ;;
esac
