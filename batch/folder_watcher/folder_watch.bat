@echo off

pushd %USERPROFILE%\Downloads

set filename=""
for %%F in (%1) do set filename=%%~nxF
 
call :testzip %1
 
goto:eof

:testzip 
  echo %1 | grep .*zip
  IF %ERRORLEVEL%==0 ( 
    call :extract "%filename%" 
    exit /b 0
  )
  echo %1 | grep .*7z
  IF %ERRORLEVEL%==0 ( 
    call :extract "%filename%" 
    exit /b 0
  )
  exit /b 1

:extract
  set targetdir="%USERPROFLE%\Downloads\%filename%"
  echo "%PROGRAMFILES%\7-zip\7z.exe" x -y "%1"
  "%PROGRAMFILES%\7-zip\7z.exe" x -y %1
  del /F /Q %1
  goto :eof


popd
