@ECHO off
:: testbox: title="date via installed POSIX `date` command (coreutils)"
:: Call the function
CALL :SHOWDATE
GOTO :EOF

:: Unlike i01/i02 (parsing %DATE% locally, either by fixed positions or
:: splitting on "/"), this shells out to a real POSIX/GNU-compatible
:: `date` binary and lets it format the date directly with the standard
:: `+FORMAT` syntax - no locale-specific parsing needed at all. Requires
:: Microsoft's coreutils-for-Windows port
:: (https://github.com/microsoft/coreutils) installed - neither real
:: Windows' nor Wine's builtin `date` command supports `+FORMAT` (Wine's
:: prints "Not Yet Implemented", confirmed directly).
::
:: Full, quoted path - confirmed directly: real Windows' cmd.exe builtin
:: `date` command claims the bare "date"/"date.exe" name outright even
:: with the .exe extension (unlike Wine, where .exe genuinely bypasses
:: the builtin - the technique this script originally relied on). It also
:: isn't on PATH by default once installed. Only an actual path reaches
:: the real coreutils binary at all here, and the space in
:: "C:\Program Files\..." needs quoting or cmd.exe only sees "C:\Program"
:: as the command.
::
:: Captured via a plain redirect + SET /P into a fixed relative filename,
:: not FOR /F's own 'command'-capture form: confirmed directly - a
:: quoted, space-containing exe path inside FOR /F's single-quoted
:: command gets mis-tokenized (the same class of nested-quoting problem
:: as a quoted format string, which is why the format string below still
:: avoids literal spaces the same way the original did). A literal
:: %TEMP% in the same statement as the %%B/%%d/%%Y format specifiers also
:: mis-parses - both share the % sigil and get paired with each other
:: (confirmed directly) - so the capture file is a plain relative name in
:: the current directory instead, deleted right after reading it back.
:SHOWDATE
  :: Test for date.exe
  SET "DATE_EXE="
  FOR %%a IN (date.exe) DO SET "DATE_EXE=%%~$PATH:a"
  IF NOT DEFINED DATE_EXE (
    >&2 ECHO ERROR: date.exe was not found on PATH.
    EXIT /B 127
  )

  :: Capture Date using CoreUtils date.exe
  "%DATE_EXE%" +%%B_%%d,_%%Y > date_capture.tmp
  SET /P RAW=<date_capture.tmp
  DEL date_capture.tmp
  SET TODAY=%RAW:_= %
  ECHO Today is %TODAY%.
GOTO :EOF
