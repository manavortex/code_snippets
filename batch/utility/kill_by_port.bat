@echo off
set port=%*
set pid=

REM > kill_by_port.bat 8080


FOR /F "tokens=5 delims= " %%P IN ('netstat -a -n -o ^|findstr :%port%') DO (
  set pid=%%P
  goto :kill
)
goto :eof

:kill
  FOR /F "tokens=1 delims= " %%Q IN ('tasklist ^|findstr %pid%') DO (
    echo "%%Q (%pid%) listening on port %port%, trying to kill..."
    TASKKILL /PID %pid% || echo error
  )
  goto :eof
