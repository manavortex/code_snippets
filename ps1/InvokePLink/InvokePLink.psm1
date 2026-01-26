function Invoke-Plink {
    
    <#
        Based on https://schneegans.de/windows/pwsh-invoke-plink/ - this one takes username, password, and hostname
        
        .SYNOPSIS
            Executes a remote command via Plink.
    
        .PARAMETER username
            The username
    
        .PARAMETER password
            The password
			
        .PARAMETER host
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
        $host,
        
        [AllowEmptyString()]
        [Parameter]
        [string[]]
        $Command,

        
        [Parameter()]
        [ValidateSet( 'Throw', 'Merge', 'Discard', 'Split' )]
        [string]
        $StandardErrorBehavior = 'Throw'
    );

    [string] $Command = $Command # | Join-String -Separator "`n";
    $exe = "$env:ProgramFiles\PuTTY\plink.exe";
  
    
    $OutputFile = [System.IO.Path]::GetTempFileName();
    $ErrorFile = [System.IO.Path]::GetTempFileName();
    
    try {
        switch( $StandardErrorBehavior ) {
            'Throw' {
                $null | & $exe -ssh $username@$host -pw $password "$Command" 1>$OutputFile 2>$ErrorFile;
                $ErrorContent = Get-Content -LiteralPath $ErrorFile;
                if( $ErrorContent ) {
                    throw $ErrorContent;
                } else {
                    Get-Content -LiteralPath $OutputFile;
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
