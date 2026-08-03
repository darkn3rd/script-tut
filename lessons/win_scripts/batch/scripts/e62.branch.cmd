@echo off
REM testbox: title="grep regex classification"
REM get input
set /p keypress=Input a character:

REM Simulate case/switch through labels, goto, and if - same technique as
REM  e61, but using grep instead of findstr. Wine's findstr doesn't
REM  implement character-range regex ([abc], [^a-z]) at all (see
REM  wine/programs/findstr/main.c's match_regexp() - explicit FIXME),
REM  which is why e61 has to spell out every letter instead of using a
REM  proper [a-z] range. A real grep.exe (e.g. `choco install grep` on
REM  Windows) supports ranges correctly and case-sensitively, no
REM  workaround needed.
REM
REM Full, quoted path to grep.exe (Microsoft's coreutils-for-Windows
REM  port) - confirmed directly: it isn't on PATH by default even once
REM  installed, and the space in "C:\Program Files\..." needs quoting or
REM  cmd.exe only sees "C:\Program" as the command (bare "grep" fails to
REM  resolve at all, unlike "date" - grep has no builtin to silently fall
REM  back to).
SET GREP="C:\Program Files\coreutils\bin\grep.exe"

REM Test for digit with grep
ECHO %keypress% | %GREP% -q "[0-9]"
IF %ERRORLEVEL% EQU 0 (ECHO  Digit) & (GOTO ENDCASE)

REM Test for uppercase letter
ECHO %keypress% | %GREP% -q "[A-Z]"
IF %ERRORLEVEL% EQU 0 (ECHO  Uppercase letter) & (GOTO ENDCASE)

REM Test for lowercase letter
ECHO %keypress% | %GREP% -q "[a-z]"
IF %ERRORLEVEL% EQU 0 (ECHO  Lowercase letter) & (GOTO ENDCASE)

REM Default output if nothing is found
ECHO  Punctuation, whitespace, or other
:ENDCASE
