@echo off
setlocal EnableDelayedExpansion 

REM call like start_if_not_running.bat "ExecutableName.exe" "C:\Path\To\Executable"

if ["%~1"] equ [""] (
	echo Please call script with argument "window title"
	goto :eof
)


if tasklist /FI "IMAGENAME eq %~1" 2>NUL | find /I /N "%~1">NUL
    if "%ERRORLEVEL%"=="1" (
		start "%~2" "%~1"
)

REM example: Outlook
REM tasklist /FI "IMAGENAME eq OUTLOOK.exe" 2>NUL | find /I /N "OUTLOOK.exe">NUL
REM   if "%ERRORLEVEL%"=="1" (
REM 		start "C:\Program Files (x86)\Microsoft Office\Office16" "OUTLOOK.exe"
REM   )
