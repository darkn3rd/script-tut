@ECHO off
REM Output Multiline Text - cmd.exe has no multi-line string literal, no
REM  heredoc, and no clean way to concatenate lines into one value (the
REM  closest is an obscure "linefeed variable" trick via delayed
REM  expansion) - so this is the "no multi-line facility" case: each
REM  line just gets its own ECHO, one call apiece.
ECHO "The person who moves a mountain begins
ECHO  by carrying away small stones."
ECHO.
ECHO    - Confucious
ECHO.
ECHO "Yesterday I was clever, so I wanted to change the world.
ECHO  Today I am wise, so I am I changing myself."
ECHO.
ECHO    - Rumi
ECHO.
ECHO "Action speaks louder than words,
ECHO    but not nearly as often."
ECHO.
ECHO    - Mark Twain
ECHO.
ECHO "A designer knows he has achieved perfection
ECHO  not when there is nothing left to add, but
ECHO  when there is nothing left to take away."
ECHO.
ECHO    - Antoine de Saint-Exupery
ECHO.
ECHO "There is no greater wealth than wisdom,
ECHO  no greater poverty than ignorance"
ECHO.
ECHO    - Ali bin Abu-Talib
ECHO.
