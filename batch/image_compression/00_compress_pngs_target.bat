@echo off
set INPUTFILE=

:: Parameter: 
:: 1 for compress_png
:: 2 for _really_ compress png
:: 3 for convert jpg
:: 4 for converting jpg and deleting
set TYPE=%~1
set BATCHFILE=

IF "%TYPE%" == "" (
	GOTO getType
	goto :EOF
)

:getType
	echo Please select file operation:
	echo.   1 - compress PNGs
	echo.   2 - compress PNGs with compression level 6
	echo.   3 - convert JPG
	echo.   4 - convert JPG and delete original file
	echo.   q - abort
	
	set /p TYPE=
	set TYPE=%TYPE:~,1%
	
	if "%TYPE%" == "q" (
		goto :eof
	)	
	if /i "%TYPE%" EQU "1" (
		echo selected PNG compression
		set BATCHFILE=01_compress_pngs.bat
		goto getInputFile
	)
	if /i "%TYPE%" EQU "2" (
		echo selected PNG compression level 6
		set BATCHFILE=01_REALLY_compress.bat
		goto getInputFile
	)
	if /i "%TYPE%" EQU "3" (
		echo selected JPG conversion
		set BATCHFILE=01_convert_jpg.bat
		goto getInputFile
	)
	if /i "%TYPE%" EQU "4" (
		echo selected JPG conversion with deletion of original file.
		echo Deletion can't be undone. Continue? [Y]
		set /p REPLY=
		set REPLY=%REPLY:~,1%
		if Not "%REPLY%" == "Y" (
			goto :getType
		)	
		set BATCHFILE=02_convert_jpg_and_delete.bat
		goto getInputFile
	)
	echo Please enter a value between 1 and 4
	goto :getType

:getInputFile 
	echo Please specify target file or q to abort
	set /p answer=
	IF "%answer%" == "" (
		goto :getInputFile		
	)
	goto :evaluateAnswer
	
:evaluateAnswer
	::Remove quotes
	set INPUTFILE=%answer%
	::Remove quotes
	set INPUTFILE=%INPUTFILE:"=%
	::Remove trailing slash
	IF %INPUTFILE:~-1%==\ SET INPUTFILE=%INPUTFILE:~0,-1%
	
	if "%INPUTFILE%" == "q" (
		goto :eof
	)
	
	:: Find out if it's a directory
	pushd "%INPUTFILE%\" 2>nul
	
	:: not a directory
	if errorlevel 1 ( 
		:: not even existing!
		if not exist "%INPUTFILE%" (
			echo %INPUTFILE% doesn't exist. Please enter a valid file.
			echo Drag-and-drop is supported.
			goto :getInputFile
		)
		echo Converting file %INPUTFILE%...
		goto :runfile
	)
	
	echo Converting files in directory %INPUTFILE%...
	set INPUTFILE=
	goto :runfile	

:runfile
	%~dp0%BATCHFILE% "%INPUTFILE%"
	
	popd
	goto :eof

