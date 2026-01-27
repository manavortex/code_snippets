$exe = "$env:ProgramFiles\PuTTY\plink.exe";  
function CheckForPlinkExe() {
	Write-Host "Checking for plink.exe..."
	if ([System.IO.File]::Exists($exe)) {
		Write-Host "Found plink.exe at $exe"
		return
	}
	
	try {
		# Get-Command looks for executables in the system's PATH.
		$exe = (Get-Command plink.exe -ErrorAction Stop).Source
		Write-Host "plink.exe found at: $exe"
	}
	catch {
		throw "Custom Error: plink.exe not found in default location $env:ProgramFiles\PuTTY\plink.exe or in your PATH. Please install PuTTY (which includes plink.exe)."
	}
}

function Invoke-Plink {
    
    <#
        .SYNOPSIS
            Executes a remote command via Plink for use within an automated pipeline.
            The username
    
        .PARAMETER password
            The password
			
        .PARAMETER hostname
            Host to connect to (IP or hostname) for ssh -v
            
        .PARAMETER Command
            One or more commands to execute in the remote session.

        .PARAMETER StandardErrorBehavior
            Specifies how to handle output written to stderr by the remote command:
            • 'Throw' will raise an exception if any output was written to stderr.
            • 'Merge' will combine stdout and stderr output, similar to a console.
            • 'Discard' will simply omit any stderr output.
            • 'Split' will return stdout and stderr output in two distinct properties.
    #>
    
    [CmdletBinding( DefaultParameterSetName = 'Auto' )]
    param(
        [Parameter( Mandatory )]
        [string]
        $username,
		
        [Parameter( Mandatory )]
        [string]
        $password,
        
        [Parameter( Mandatory )]
        [string]
        $hostname,
		        
        [AllowEmptyString()]
        [Parameter()]
        [string[]]
        $Command,		
        
        [Parameter()]
        [ValidateSet( 'Throw', 'Merge', 'Discard', 'Split' )]
        [string]
        $StandardErrorBehavior = 'Throw'
    );

    # [string] $Command = $Command | Join-String -Separator "`n";
	CheckForPlinkExe
    
    $OutputFile = [System.IO.Path]::GetTempFileName();
    $ErrorFile = [System.IO.Path]::GetTempFileName();

	# optional: to disable strict host checking, remove the next two comments
	# $hostKey=(Write-Output "i`n" | plink -shh -batch -v $hostname -l $username -pw $password) 2>&1 | select-string -Pattern 'ssh-rsa \d+ (.+)' | % {($_ -split " ")[2] }
		
	$params = @(
		"-ssh",
		"-batch",
		"-v", "$hostname",
		"-l", "$username",
		"-pw", "$password"
		# ,"-hostkey", "$hostkey"		
	) 	
	
    try {
        switch( $StandardErrorBehavior ) {
            'Throw' {
                $null | & $exe @params 1>$OutputFile 2>$ErrorFile;
                $ErrorContent = Get-Content -LiteralPath $ErrorFile;
                if( $ErrorContent ) {
                    throw $ErrorContent;
                } else {
                    Get-Content -LieralPath $OutputFile;
                }
            }
            'Merge' {
                $null | & $exe $params 1>$OutputFile 2>&1;
                Get-Content -LiteralPath $OutputFile;
            }
            'Discard' {
                $null | & $exe $params 1>$OutputFile 2>$null;
                Get-Content -LiteralPath $OutputFile;
            }
            'Split' {
                $null | & $exe $params 1>$OutputFile 2>$ErrorFile;
                [pscustomobject] @{
                    Output = Get-Content -LiteralPath $OutputFile;
                    Errors = Get-Content -LiteralPath $ErrorFile;
                };
            }
        }
    } finally {
        Remove-Item -LiteralPath $OutputFile -ErrorAction 'SilentlyContinue';
        Remove-Item -LiteralPath $ErrorFile -ErrorAction 'SilentlyContinue';
    }
}
