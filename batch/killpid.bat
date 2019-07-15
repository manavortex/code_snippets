@echo off
set pid=%*

REM >killpid.bat 1234 
REM >killpid.bat -f 1234 

IF "%1"=="-f" GOTO :forcekill
IF "%1"=="-F" GOTO :forcekill

FOR /F "tokens=1 delims= " %%Q IN ('tasklist ^|findstr %pid%') DO (
  TASKKILL /PID %pid% && echo killed %%Q (pid %pid%^) || echo error
)
goto :eof

:forcekill
  set pid=%2
  FOR /F "tokens=1 delims= " %%Q IN ('tasklist ^|findstr %pid%') DO (
    TASKKILL /F /PID %pid% && echo killed %%Q (pid %pid%^) || echo error
  )
  goto :eof
