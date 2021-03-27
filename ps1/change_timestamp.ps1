$begin=1
$end=199

foreach ($Integer in $begin..$end) { 
	$foldername = ".\foldername-$Integer"
	if (Test-Path $foldername) { 
		Start-Sleep -s 1
		Write-Host "updating $foldername"
		(Get-ChildItem -Path "$foldername" –File –Recurse) | % {
			$_.CreationTime = (Get-Date)
			$_.LastWriteTime = (Get-Date)
		}
	}
}

