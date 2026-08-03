#!/usr/bin/env bash
set -euo pipefail

COMMAND_NAME=${0##*/}

case $COMMAND_NAME in
  cmd)     USAGE='cmd <path-to-script.cmd|.bat> [args...]' ;;
  cscript) USAGE='cscript <path-to-script.js|.vbs> [args...]' ;;
  *)       printf 'wsl1-run: invoke this script as cmd or cscript\n' >&2; exit 2 ;;
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

WIN_PATH=$(wslpath -w "$SCRIPT_PATH")

# Prevent WSL1 warnings when Windows inherits a Linux-only working directory.
cd /mnt/c/Windows/Temp

case $COMMAND_NAME in
    cmd)     exec cmd.exe /c "$WIN_PATH" "$@" ;;
    cscript) exec cscript.exe //Nologo "$WIN_PATH" "$@" ;;
esac
