# use with https://github.com/stax76/run-hidden to keep a bunch of background processes running, even when they crash
# can run this from windows task scheduler as periodic task
# run program: set to executable downloaded above
# arguments: 
# -ExecutionPolicy Bypass -File "C:\path\to\keep_processes_running.ps1"

# Define the map of processes and their executable paths
$processes = @{
    "olk" = "C:\Program Files\WindowsApps\Microsoft.OutlookForWindows_1.2024.111.100_x64__8wekyb3d8bbwe\olk.exe"
    "msedge" = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    "ms-teams" = "C:\Program Files\WindowsApps\MSTeams_24004.1307.2669.7070_x64__8wekyb3d8bbwe\ms-teams.exe"
}

# Loop through each key-value pair in the map
foreach ($processName in $processes.Keys) {
    $executablePath = $processes[$processName]
    
    # Check if the process is running
    $isRunning = Get-Process -Name "$processName" -ErrorAction SilentlyContinue
    
    if (-not $isRunning) {
        # If the process is not running, start it from its executable in the background
        try { 
            Start-Process -FilePath "$executablePath" -WindowStyle Hidden 
        } catch { 
            Write-Host "failed to start $processName from $executablePath"
        }        
    }
}
