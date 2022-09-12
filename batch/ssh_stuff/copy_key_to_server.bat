@echo off
setlocal EnableDelayedExpansion
REM =========================================================================================================
set KEY_NAME=id_rsa_twms_controller
set KEYFILE="%USERPROFILE%\.ssh\%KEY_NAME%.pub"
set CONFIGFILE="%USERPROFILE%\.ssh\config"
set KNOWN_HOSTS="%USERPROFILE%\.ssh\known_hosts"
set REMOTE_PASSWORD=my_password
REM =========================================================================================================


where plink > nul
IF %ERRORLEVEL% NEQ 0 ECHO you need to install putty and add its folder to windows %%PATH%% variable!

if exist "%USERPROFILE%\.ssh\%KEY_NAME%.pub" (
  set /p KEY=<"%USERPROFILE%\.ssh\%KEY_NAME%.pub"
)

if "" == "%KEY%" (
  call :echoRed No key could be found. Please make sure that the following file exists and holds a public key:
  call :echoRed %USERPROFILE%\.ssh\%KEY_NAME%.pub
  exit 1
)

pushd %~dp0
set BATCH_DIR=%CD%
popd

set pingTimeoutRemoteIPs=

if "%~1"=="" (
  call :copy_file
) ELSE (
  type NUL > %TEMP%\copy_keys.txt
  for %%x in (%*) do (
    echo %%x >> %TEMP%\copy_keys.txt
  )
)

REM iterate over list with IPs
for /F "tokens=*" %%A in (%TEMP%\copy_keys.txt) do (
  call :processIP %%A
)

goto :end

:copy_file    
  (echo F | xcopy /Y "%BATCH_DIR%\allIps.txt" "%TEMP%\copy_keys.txt") > nul
  if not %errorlevel% == 0 ( 
    call :echoRed Please either call the script with IP addresses as parameters, or create the following file with one IP per line:
    call :echoRed %BATCH_DIR%\allIps.txt
  )
  goto :eof

:processIP
  set IP=%1
  if "" == "%IP%"  goto :eof
  if /i "%IP:~0,1%"=="#" goto :eof
  
  ping -w 1000 -n 1 %IP% | find /I "Lost = 0" > nul
  REM not responding to ping
  if not %errorlevel% == 0 (
    set pingTimeoutRemoteIPs=%pingTimeoutRemoteIPs% %IP%
    goto :eof
  )

  REM hostname will be the last two bits of the IP
  set HOSTNAME=%IP:192.168.=%
  
  echo Copying key to %IP% (writing host %HOSTNAME%).
  
  REM delete key from known-hosts file
  call :rewriteKnownHost
  
  REM make sure that we can establish a connection. Then, check if key is already authorized, or add it to authorized keys.
  echo y | plink -ssh -pw %REMOTE_PASSWORD% root@%IP% "grep -q '%KEY%' ~/.ssh/authorized_keys && (echo 'already authorized'; exit 2) || (echo %KEY% >> ~/.ssh/authorized_keys; exit 0)"
  
  REM add it to config file if it hasn't been added
  find "%IP%" %CONFIGFILE% > nul || (    
    echo. >> %CONFIGFILE%
    echo Host %HOSTNAME%>> %CONFIGFILE%
    echo    HostName %IP% >> %CONFIGFILE%
    echo    PreferredAuthentications publickey,password >> %CONFIGFILE%
    echo    User root >> %CONFIGFILE%
    echo    IdentityFile %USERPROFILE%\.ssh\%KEY_NAME% >> %CONFIGFILE%

    call :echoGreen Host %IP% added to config file. You can now connect via "ssh %HOSTNAME%"
  )
  echo.
  
  goto :eof

:rewriteKnownHost
  if "" == "%KNOWN_HOSTS%" goto :eof
  if not exist "%KNOWN_HOSTS%" goto :eof
  findstr /V "%IP%" "%KNOWN_HOSTS%" > "%TEMP%\known_hosts"
  xcopy /Y "%TEMP%\known_hosts" "%KNOWN_HOSTS%" > nul
  del "%TEMP%\known_hosts"
  REM ssh-keyscan -H %IP% >> %KNOWN_HOSTS%
  goto :eof

:echoRed
  %Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Red %*
  goto :eof
  
:echoYellow
  %Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Yellow %*
  goto :eof
  
:echoGreen
  %Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Green %*
  goto :eof
  
:end
  IF EXIST ("%TEMP%\copy_keys.txt") (
    rm "%TEMP%\copy_keys.txt"
  )  
  if not "%pingTimeoutRemoteIPs%" == "" (  
    call :echoYellow Failed to reach the following IPs
    for %%x in (%pingTimeoutRemoteIPs%) do (
      echo.   %%x
    )
  )
  

exit /b 0

