# ===============================================================================
# customize here
# ===============================================================================

# list of applications: key => value storage
# key: name of executable for Get-Process (e.g. "KeePass")
# value: full path to the file you want to run if the executable isn't running
$applications = @{
    "KeePass" = "C:\Program Files (x86)\KeePass2x\KeePass.exe";
    "AutoHotkeyV2" = "$env:userprofile\Dokumente\AutoHotkey.ahk";    
}

# comment back in to wait 30 seconds (e.g. if you run this after boot)
# Start-Sleep -Seconds 30

# ===============================================================================
# stop customizing
# ===============================================================================

foreach ($appName in $applications.Keys) {
  Write-Host "`nChecking for $appName..."

  if (Get-Process -Name $appName.Replace(".exe", "") -ErrorAction SilentlyContinue)) {
		continue		
  }
	
  $filePath = $applications[$appName]
	
  Write-Host "Not running. Starting $filePath..."
  Start-Process -FilePath $filePath
  Start-Sleep -Seconds 1
}
