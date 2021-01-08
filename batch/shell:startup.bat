
REM wait 2 seconds
ping -n 2 127.0.0.1 >nul

tasklist | find /i "AutoHotkey.exe"
if %ERRORLEVEL% NEQ 0 ( start "" "E:\Program Files\AutoHotkey\AutoHotkey.exe" %USERPROFILE%\Documents\AutoHotkey.ahk )

REM wait 8 seconds
ping -n 8 127.0.0.1 >nul

tasklist | find /i "Origin.exe"
if %ERRORLEVEL% NEQ 0 ( start "" "C:\Program Files (x86)\Origin\Origin
 .exe" )

tasklist | find /i "Monosnap.exe"
if %ERRORLEVEL% NEQ 0 ( start "" "%USERPROFILE%\AppData\Local\Monosnap\App\Monosnap.exe" )

tasklist | find /i "Minion.exe"
if %ERRORLEVEL% NEQ 0 ( start "" "%USERPROFILE%\AppData\Local\Minion\Minion.exe")

tasklist | find /i "steam.exe"
if %ERRORLEVEL% NEQ 0 ( start "" "D:\Program Files\Steam\steam.exe")

tasklist | find /i "Evernote.exe"
if %ERRORLEVEL% NEQ 0 ( start "" "%USERPROFILE%\AppData\Local\Programs\evernote-client\Evernote.exe")

tasklist | find /i "EpicGamesLauncher.exe"
if %ERRORLEVEL% NEQ 0 ( start "" "D:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe")



REM ssh-agent
