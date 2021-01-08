@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ImageMagick needs to be on path
WHERE magick
if %ERRORLEVEL% NEQ 0 PATH=%PATH%;D:\Program^ Files\ImageMagick-7.0.10-Q16-HDRI

set "INFILE_EXTENSION=.png"
set "OUTFILE_EXTENSION=.jpg"

REM if run without parameter, run on all files in directory
IF "%~1" == "" GOTO RUNRECURSIVE

for %%f in (%*) do call :convertFile %%f
goto :EOF

:RUNRECURSIVE
	FOR /R %%f IN (*.png) do call :convertFile %%f
	goto :EOF

:convertFile
	set filename=%*
		
	REM set destination file
	set "OUTFILE=!filename:%INFILE_EXTENSION%=%OUTFILE_EXTENSION%!"
	
	REM strip "" from filename
	set filename_without_quotes=%filename:"=%
	
	echo filename is %filename%, outfile will be %OUTFILE%	
	
	REM file already touched
	set "fileprefix=%filename_without_quotes:~0,1%"
	if "%fileprefix%"=="_" (
		if exist %OUTFILE% goto :EOF
	)
	
	magick convert "%filename_without_quotes%" -verbose -strip -interlace Plane -colorspace RGB %OUTFILE%
	
	REM already optimized	
	set _filename=%~nx1
	set _filepath=%~dp1
	move %filename% "%_filepath%_%_filename%"	
		
	goto :EOF

endlocal
