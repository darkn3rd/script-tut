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
:: Called as "date.exe", not bare "date" - both real Windows' cmd.exe and
:: Wine's builtin `date` command claim that bare name first; adding the
:: .exe extension always bypasses builtin lookup and searches PATH for
:: the real file instead, on either. No path prefix needed beyond that -
:: Microsoft's coreutils installer adds its own bin/ directory to PATH.
::
:: The format string uses "_" instead of spaces/commas-with-a-space, and
:: FOR /F's own single-quoted command capture doesn't correctly handle a
:: *second* double-quoted segment inside it (confirmed directly - the
:: quotes needed around a space-containing "+%%B %%d, %%Y" argument get
:: mis-tokenized, dropping the whole command). Formatting with no
:: literal spaces avoids needing that second quoted segment at all; the
:: "_" are swapped back to spaces afterward with plain variable
:: substitution.
:SHOWDATE
  FOR /F "delims=" %%a IN ('date.exe +%%B_%%d,_%%Y') DO SET RAW=%%a
  SET TODAY=%RAW:_= %
  ECHO Today is %TODAY%.
GOTO :EOF
