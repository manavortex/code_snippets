@echo off

REM call like conditionally_add_to_path.bat "%USERPROFILE%\bin"

set folder=%~1
if not exist "%folder%" ( 
	echo "%folder% doesn't exist"
	goto :eof 
)

set searchpath="%folder%\*.exe"

for %%a in ( %searchpath% ) do (
	set fileVariable=%%a
	where %%~nxa
	if %errorlevel% EQU 1 ( 
		goto :addpath
	) 
	
)

:addpath
	setx PATH "%PATH%;%folder%"
	:goto eof


REM popd

