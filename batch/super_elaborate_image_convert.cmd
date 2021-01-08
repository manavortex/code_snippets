@echo off
setlocal 

REM ImageMagick needs to be on path
WHERE magick
if %ERRORLEVEL% NEQ 0 PATH=%PATH%;D:\Program^ Files\ImageMagick-7.0.10-Q16-HDRI

set "INFILE_EXTENSION=.png"
set "OUTFILE_EXTENSION=.jpg"

REM 10mb
set /a "maxbytesize=10000000"

REM if run without parameter, run on all files in directory
IF "%~1" == "" GOTO RUNRECURSIVE

for %%f in (%*) do (
	call :convertFile %%f	
)
goto :EOF

:RUNRECURSIVE
	FOR /R %%f IN (*%INFILE_EXTENSION%) DO (
		call :convertFile %%f
	)
	goto :EOF

:convertFile
	set filename="%~1"
	
	set "OUTFILE=!filename:%INFILE_EXTENSION%=%OUTFILE_EXTENSION%!"
	Echo.%filename% | findstr /C:"DragonAgeInquisition">nul && (
		REM echo converting and resizing %%f
		magick convert "filename" -verbose -strip -interlace Plane -colorspace RGB -resize "1920x1080" "!OUTFILE!"	
		if exist "!OUTFILE!" del "%filename%"
	) || (
		magick convert "%filename%" -verbose -strip -interlace Plane -colorspace RGB "!OUTFILE!"
		call :evaluateFileSize %filename%
	)
	goto :EOF
	
:evaluateFileSize
	set size=%~z1	
	set /a sizediff=%maxbytesize%-%size%
	
	REM if the file is < 10mb, don't try to optimize
	if %sizediff% gt 0 goto :eof
	
	REM optipng needs to be on path
	WHERE optipng
	if %ERRORLEVEL% NEQ 0 PATH=%PATH%;C:\01_apps\bin
	start cmd.exe @cmd /k "optipng -o2 -strip all -preserve %~1"	
	
	goto :eof

endlocal
