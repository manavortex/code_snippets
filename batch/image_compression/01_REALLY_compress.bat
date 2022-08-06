@echo off

REM This script will compress a PNG. Full compression, slow af, lots of compression (>70%).

REM add optipng to path if necessary
WHERE optipng 2>nul
if %ERRORLEVEL% NEQ 0 PATH=%PATH%;C:\01_apps\bin

:: if run without parameter, run on all files in directory
IF "%~1" == "" GOTO RUNRECURSIVE


for %%f in (%*) do call :convertFile %%f
goto :EOF

:RUNRECURSIVE
	FOR /R %%f IN (*.png) DO optipng -o2 -strip all "%%f"
	goto :EOF

:convertFile
	set filename=%*
	
	:: If you want to maximize your compression ratio with a fairly significant time tradeoff at larger file sizes, you can use the -o7 switch.
	:: optipng -o7 -strip all -preserve %filename%
	optipng -o7 -strip all -preserve %filename%

	goto :EOF
