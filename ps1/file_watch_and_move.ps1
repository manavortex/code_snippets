

$sourcePath = "C:\ReshadeScreenshotsTemp"
$fileExtensions = '.png','.jpg'

$destpath = "$env:USERPROFILE\Pictures\Screenshots"

$logfile = "$destpath\log.txt"
$filelist =  @()

### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $destPath
    $watcher.Filter = $fileFilter
    $watcher.IncludeSubdirectories = $false
    $watcher.EnableRaisingEvents = $true
	
Function includeFile($filepath) {
    $extn = [IO.Path]::GetExtension($filepath)
    return ($fileExtensions -contains  $([IO.Path]::GetExtension($filepath)))
}

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = { 
		$path = $Event.SourceEventArgs.FullPath
        if (includeFile($Event.SourceEventArgs.FullPath)) {
        	$name = $Event.SourceEventArgs.Name
	        $changeType = $Event.SourceEventArgs.ChangeType		
        
            $logline = "$(Get-Date), $changeType, $path, $name"
		    Add-content "$logfile" -value $logline
		
		    $filelist += "$name"
        }        
	}
	

### DECIDE WHICH EVENTS SHOULD BE WATCHED 
   Register-ObjectEvent $watcher "Created" -Action $action    
    
    foreach ($file in GCI "$sourcePath") {
        if (includeFile($file)) {
            $name = $file.Name
		    $filelist += "$name"
        }
    }
    
    while ($true) {
		sleep 5
        $movedFiles =  @()
        foreach ($name in $filelist) {
            $path = "$sourcePath\$name"
			$diff=((ls $path).LastWriteTime - (Get-Date)).TotalSeconds
            
			Add-content "$logfile" -value $logline
			if ($diff -lt 1.0) { 
                $movedFiles += $name
				$logline = "moving $path to $destpath\$name"
                Write-Output $logline
				Move-Item -Path "$path" -Destination "$destpath"				
			}	
        }

        $filelist | Where-Object { $movedFiles -notcontains $_ }
	}
