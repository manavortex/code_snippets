# ################################################################################################
# just system log
# ################################################################################################
$events = Get-WinEvent -FilterHashtable @{
    LogName='System'
    StartTime=(Get-Date).AddMinutes(-5)
} | ForEach-Object {
    [PSCustomObject]@{
        Time = $_.TimeCreated.ToString('HH:mm:ss')
        Level = $_.LevelDisplayName
        LogName = $_.LogName
        EventId = $_.Id
        Description = if ($_.Message) { 
            ($_.Message -replace '\s+', ' ').Trim()
        } else { 'N/A' }
    }
}

$events | Format-Table -AutoSize -Wrap



# ################################################################################################
# all logs
# ################################################################################################

$events = @()
$logs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | 
    Where-Object {$_.RecordCount -gt 0 -and $_.IsEnabled}

foreach ($log in $logs) {
    try {
        $logEvents = Get-WinEvent -FilterHashtable @{
            LogName = $log.LogName
            StartTime = (Get-Date).AddMinutes(-5)
        } -MaxEvents 50 -ErrorAction Stop
        
        foreach ($event in $logEvents) {
            $events += [PSCustomObject]@{
                Time = $event.TimeCreated.ToString('HH:mm:ss.fff')
                Level = $event.LevelDisplayName
                Provider = $event.ProviderName
                EventId = $event.Id
                Description = if ($event.Message) { 
                    ($event.Message -replace '\s+', ' ').Trim()
                } else { 'N/A' }
            }
        }
    }
    catch {
        # Silently continue
        continue
    }
}

$events | Sort-Object Time -Descending | Format-Table -AutoSize -Wrap
