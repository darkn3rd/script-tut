@ECHO OFF
SET q_coffee=0
SET q_espresso=0
SET q_latte=0
SET q_machiato=0
SET q_capucino=0
SET q_mocha=0
SET q_tea=0

IF "%1"=="" (
  SET /A q_coffee=%RANDOM% %% 3
  SET /A q_espresso=%RANDOM% %% 3
  SET /A q_latte=%RANDOM% %% 3
  SET /A q_machiato=%RANDOM% %% 3
  SET /A q_capucino=%RANDOM% %% 3
  SET /A q_mocha=%RANDOM% %% 3
  SET /A q_tea=%RANDOM% %% 3
) ELSE (
  FOR %%A IN (%*) DO (
    FOR /F "tokens=1,2 delims=:" %%K IN ("%%A") DO (
      IF "%%K"=="Coffee" SET q_coffee=%%L
      IF "%%K"=="Espresso" SET q_espresso=%%L
      IF "%%K"=="Latte" SET q_latte=%%L
      IF "%%K"=="Machiato" SET q_machiato=%%L
      IF "%%K"=="Capucino" SET q_capucino=%%L
      IF "%%K"=="Mocha" SET q_mocha=%%L
      IF "%%K"=="Tea" SET q_tea=%%L
    )
  )
)

SET ORDER=
IF NOT %q_capucino%==0 SET ORDER=%ORDER%,Capucino:%q_capucino%
IF NOT %q_coffee%==0 SET ORDER=%ORDER%,Coffee:%q_coffee%
IF NOT %q_espresso%==0 SET ORDER=%ORDER%,Espresso:%q_espresso%
IF NOT %q_latte%==0 SET ORDER=%ORDER%,Latte:%q_latte%
IF NOT %q_machiato%==0 SET ORDER=%ORDER%,Machiato:%q_machiato%
IF NOT %q_mocha%==0 SET ORDER=%ORDER%,Mocha:%q_mocha%
IF NOT %q_tea%==0 SET ORDER=%ORDER%,Tea:%q_tea%

REM strip the leading comma the loop above always adds before the
REM  first real entry
IF "%ORDER:~0,1%"=="," SET ORDER=%ORDER:~1%

SET MY_ORDERS=%ORDER%

REM bare SET with no arguments already lists every variable as plain
REM  "KEY=value" lines - exactly the format this dump needs, no
REM  reformatting required.
SET > dump_env.out

ECHO MY_ORDERS set, Hit Return to continue
SET /P _=

DEL /Q dump_env.out
