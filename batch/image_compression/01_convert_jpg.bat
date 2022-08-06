@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM This script will convert a PNG to JPG.

REM ImageMagick needs to be on path
WHERE magick 2>nul
if %ERRORLEVEL% NEQ 0 (
	echo you need to install image magick and add it to your PATH variable, see readme
	:: or change the line below
	:: PATH=%PATH%;C:\Program^ Files\ImageMagick-7.0.10-Q16-HDRI
	goto :eof
)

set "INFILE_EXTENSION=.png"
set "OUTFILE_EXTENSION=.jpg"

:: if run without parameter, run on all files in directory
IF "%~1" == "" GOTO RUNRECURSIVE

for %%f in (%*) do call :convertFile %%f
goto :EOF

:RUNRECURSIVE
	FOR /R %%f IN (*.png) do call :convertFile %%f
	goto :EOF

:convertFile
	set "filename=%*"

	:: strip "" from filename
	set filename_without_quotes=%filename: =^ %
	
	:: set destination file
	set "OUTFILE=!filename:%INFILE_EXTENSION%=%OUTFILE_EXTENSION%!"
	
	if exist "%OUTFILE%" goto :EOF
	
	echo %filename%
	magick convert %filename% -verbose -strip -interlace Plane -colorspace RGB %OUTFILE%
	
	:: already optimized	
	:: set _filename=%~nx1
	:: set _filepath=%~dp1
	:: move %filename% "%_filepath%_%_filename%"	
		
	goto :EOF

endlocal