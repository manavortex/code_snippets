@echo off
setlocal EnableExtensions

REM add optipng to path if necessary
REM WHERE optipng
REM if %ERRORLEVEL% NEQ 0 PATH=%PATH%;C:\01_apps\bin

call :GetSeconds "%DATE:~-10% %TIME%"

rem Subtract seconds for 4 hours (4 * 3600 seconds) from seconds value.
set /A "CompareTime=Seconds-2*3600"

REM if run without parameter, run on all files in directory
IF "%~1" == "" GOTO RUNRECURSIVE


for %%f in (%*) do call :convertFile %%f
goto :EOF

:RUNRECURSIVE
	FOR %%f IN (*.png) do call :convertFile %%f
	goto :EOF



:convertFile
	
	rem Define batch file itself as the file to compare time by default. https://stackoverflow.com/a/32670346
	set filename=%*
	set "FileToCompareTime=%filename%"
	
	rem Get seconds value for the specified file.
	for %%F in ( %FileToCompareTime% ) do (
		call :GetSeconds "%%~tF:0"
	)
		
	rem Compare the two seconds values.
	if %Seconds% GTR %CompareTime% (		
		optipng -o7 -strip all -preserve %filename%
	)
	
	endlocal
	goto :EOF


:GetSeconds
	rem If there is " AM" or " PM" in time string because of using 12 hour
	rem time format, remove those 2 strings and in case of " PM" remember
	rem that 12 hours must be added to the hour depending on hour value.
	set "DateTime=%~1"
	set "Add12Hours=0"
	if "%DateTime: AM=%" NEQ "%DateTime%" (
		set "DateTime=%DateTime: AM=%"
	) else if "%DateTime: PM=%" NEQ "%DateTime%" (
		set "DateTime=%DateTime: PM=%"
		set "Add12Hours=1"
	)

	rem Get year, month, day, hour, minute and second from first parameter.
	for /F "tokens=1-6 delims=,-./: " %%A in ("%DateTime%") do (
		rem For English US date MM/DD/YYYY or M/D/YYYY
		set "Day=%%B" & set "Month=%%A" & set "Year=%%C"
		rem For German date DD.MM.YYYY or English UK date DD/MM/YYYY
		rem set "Day=%%A" & set "Month=%%B" & set "Year=%%C"
		set "Hour=%%D" & set "Minute=%%E" & set "Second=%%F"
	)

	rem Remove leading zeros from the date/time values or calculation could be wrong.
	if "%Month:~0,1%"  EQU "0" ( if "%Month:~1%"  NEQ "" set "Month=%Month:~1%"   )
	if "%Day:~0,1%"    EQU "0" ( if "%Day:~1%"    NEQ "" set "Day=%Day:~1%"       )
	if "%Hour:~0,1%"   EQU "0" ( if "%Hour:~1%"   NEQ "" set "Hour=%Hour:~1%"     )
	if "%Minute:~0,1%" EQU "0" ( if "%Minute:~1%" NEQ "" set "Minute=%Minute:~1%" )
	if "%Second:~0,1%" EQU "0" ( if "%Second:~1%" NEQ "" set "Second=%Second:~1%" )

	rem Add 12 hours for time range 01:00:00 PM to 11:59:59 PM,
	rem but keep the hour as is for 12:00:00 PM to 12:59:59 PM.
	if "%Add12Hours%" == "1" (
		if %Hour% LSS 12 set /A Hour+=12
	)
	set "DateTime="
	set "Add12Hours="

	rem Must use 2 arrays as more than 31 tokens are not supported
	rem by command line interpreter cmd.exe respectively command FOR.
	set /A "Index1=Year-1979"
	set /A "Index2=Index1-30"

	if %Index1% LEQ 30 (
		rem Get number of days to year for the years 1980 to 2009.
		for /F "tokens=%Index1% delims= " %%Y in ("3652 4018 4383 4748 5113 5479 5844 6209 6574 6940 7305 7670 8035 8401 8766 9131 9496 9862 10227 10592 10957 11323 11688 12053 12418 12784 13149 13514 13879 14245") do set "Days=%%Y"
		for /F "tokens=%Index1% delims= " %%L in ("Y N N N Y N N N Y N N N Y N N N Y N N N Y N N N Y N N N Y N") do set "LeapYear=%%L"
	) else (
		rem Get number of days to year for the years 2010 to 2038.
		for /F "tokens=%Index2% delims= " %%Y in ("14610 14975 15340 15706 16071 16436 16801 17167 17532 17897 18262 18628 18993 19358 19723 20089 20454 20819 21184 21550 21915 22280 22645 23011 23376 23741 24106 24472 24837") do set "Days=%%Y"
		for /F "tokens=%Index2% delims= " %%L in ("N N Y N N N Y N N N Y N N N Y N N N Y N N N Y N N N Y N N") do set "LeapYear=%%L"
	)

	rem Add the days to month in year.
	if "%LeapYear%" == "N" (
		for /F "tokens=%Month% delims= " %%M in ("0 31 59 90 120 151 181 212 243 273 304 334") do set /A "Days+=%%M"
	) else (
		for /F "tokens=%Month% delims= " %%M in ("0 31 60 91 121 152 182 213 244 274 305 335") do set /A "Days+=%%M"
	)

	rem Add the complete days in month of year.
	set /A "Days+=Day-1"

	rem Calculate the seconds which is easy now.
	set /A "Seconds=Days*86400+Hour*3600+Minute*60+Second"

	rem Exit this subroutine
	goto :EOF
