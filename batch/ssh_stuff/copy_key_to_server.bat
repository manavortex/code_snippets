@echo off
REM =========================================================================================================
set KEY_NAME="id_rsa_twms_controller"
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
set script_dir="%CD%"
popd

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

goto :eof

:copy_file
  IF EXIST (%script_dir%\allIps.txt) (
    xcopy /Y "%script_dir%\allIps.txt" "%TEMP%\copy_keys.txt" > nul
  ) else (
    call :echoRed Please either call the script with IP addresses as parameters, or create the following file with one IP per line:
    call :echoRed %script_dir%\allIps.txt
  )
  goto :eof

:processIP
  set IP=%1
  if "" == "%IP%"  goto :eof
  if /i "%IP:~0,1%"=="#" goto :eof
  
  ping -w 1000 -n 1 %IP% | find /I "Lost = 0" > nul
  if not %errorlevel% == 0 (
    call :echoYellow %IP% not responding to ping. Skipping...
    goto :eof
  )

  REM hostname will be the last two bits of the IP
  set HOSTNAME=%IP:172.21=%
  
  echo Copying key to %IP% (writing host %HOSTNAME%).
  
  REM delete key from known-hosts file
  call :deleteKnownHost
  
  REM make sure that we can establish a connection. Then, check if key is already authorized, or add it to authorized keys.
  echo y | plink -ssh -pw %REMOTE_PASSWORD% root@%IP% "grep -q '%KEY%' ~/.ssh/authorized_keys && (echo 'already authorized'; exit 2) || (echo %KEY% >> ~/.ssh/authorized_keys; exit 0)"
  
  REM add it to config file if it hasn't been added
  find "%IP%" %CONFIGFILE% > nul || (
    echo Adding %IP% to %CONFIGFILE% as %HOSTNAME%...
    
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

:deleteKnownHost
  if "" == "%KNOWN_HOSTS%" goto :eof
  findstr /V "%IP%" "%KNOWN_HOSTS%" > "%TEMP%\known_hosts"
  xcopy /Y "%TEMP%\known_hosts" "%KNOWN_HOSTS%" > nul
  del "%TEMP%\known_hosts"
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

exit /b 0

