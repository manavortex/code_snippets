# ===============================================================================
# customize here
# ===============================================================================

# list of applications: key => value storage
# key: name of executable for Get-Process (e.g. "KeePass")
# value: full path to the file you want to run if the executable isn't running
$applications = @{
    "KeePass" = "C:\Program Files (x86)\KeePass2x\KeePass.exe";
    "AutoHotkeyV2" = "$env:userprofile\Dokumente\AutoHotkey.ahk";
	"OUTLOOK.exe" = "OUTLOOK.exe";
}

$applications_args = @{
  "OUTLOOK.exe" = "/select Outlook:Calendar";
}

# comment back in to wait 30 seconds (e.g. if you run this after boot)
# Start-Sleep -Seconds 30

# ===============================================================================
# stop customizing
# ===============================================================================

foreach ($appName in $applications.Keys) {
  Write-Host "`nChecking for $appName..."

  if (Get-Process -Name $appName.Replace(".exe", "") -ErrorAction SilentlyContinue) {
		continue		
  }
	
  $filePath = $applications[$appName]	
  Write-Host "Not running. Starting $filePath..."

  # get arguments from second list
  $application_args = ""    
  if ($applications_args.ContainsKey($appName)) {    
    $application_args = $applications_args[$appName]    
  }

  # start new powershell instance via cmd, so that we don't have windows lurking around forever
  cmd /c start /min "" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Start-Process -FilePath $filePath" -ArgumentList $application_args 

  # short delay for no reason (I like watching the text move)
  Start-Sleep -Seconds 0.5
}

# short delay for no reason (I like watching the text move)
Start-Sleep -Seconds 5
