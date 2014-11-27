@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
:: output string before calling function
set string=ibm
ECHO The current string is: ^"%string%^".
:: call the function
call :capitalize string
:: output results after calling function
ECHO The capitalized string is: ^"%string%^".
ENDLOCAL
GOTO :EOF

:: create the subroutine
:Capitalize
  SET %~1=!%1:a=A!
  SET %~1=!%1:b=B!
  SET %~1=!%1:c=C!
  SET %~1=!%1:d=D!
  SET %~1=!%1:e=E!
  SET %~1=!%1:f=F!
  SET %~1=!%1:g=G!
  SET %~1=!%1:h=H!
  SET %~1=!%1:i=I!
  SET %~1=!%1:j=J!
  SET %~1=!%1:k=K!
  SET %~1=!%1:l=L!
  SET %~1=!%1:m=M!
  SET %~1=!%1:n=N!
  SET %~1=!%1:o=O!
  SET %~1=!%1:p=P!
  SET %~1=!%1:q=Q!
  SET %~1=!%1:r=R!
  SET %~1=!%1:s=S!
  SET %~1=!%1:t=T!
  SET %~1=!%1:u=U!
  SET %~1=!%1:v=V!
  SET %~1=!%1:w=W!
  SET %~1=!%1:x=X!
  SET %~1=!%1:y=Y!
  SET %~1=!%1:z=Z!
GOTO :EOF
