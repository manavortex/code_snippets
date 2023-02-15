# Script will take a user input parameter, generate a hash code, convert the hash code to hexadecimal, and copy it to clipboard.


Clear-Host

# will keep previously generated entries in a file in temp
$filePath = "$env:TEMP\convert_inputParam_to_32_bit.txt"

# collision check 
$script:assignedNumbers = @(0);

# cache: will be populated from $filePath in function readHashTable
$script:htable = @{}

# global user input
$script:inputParam = 0

function readHashTable() {
    # create file if it doesn't exist
    if (-not(Test-Path -Path $filePath -PathType Leaf)) {
        New-Item -Path ($filePath)
    }
    try {        
        Get-Content $filePath | Where-Object {
            $_ -like '*:*'
        } | ForEach-Object {
            $key, $value = $_ -split '\s*:\s*', 2
            $script:htable[$key] = $value            
            $script:assignedNumbers += $value
        }   
    } catch {
        Write-host "Error: Couldn't read hash table from $filePath" -foregroundcolor red
        Write-host "Overwrite with empty file? y/[n]"
        $response = Read-Host
        if ( $response -eq "y" ) {
            Set-Content $filePath ""
        } else {
            Write-host "Not using cache"
        }
    }   

}


function writeHashTable() {    
    $script:htable.keys | %{ Add-Content $filePath "$_ : $($script:htable.$_)" }
}

function GetRandomNumber() {

    $numericInputParam = $inputParam.GetHashCode();
    $ret = $numericInputParam

    if ( $script:assignedNumbers -contains $numericInputParam) {
        if (-Not $script:htable.ContainsKey($inputParam)) {
            $ret= Get-Random
            Write-host "Error: Collision for $inputParam (hash $numericInputParam)! Will use random numeric value: $ret" -foregroundcolor red
        } else {        
            $ret = $htable[$inputParam]
        }
        
     } else {
        $script:assignedNumbers += $ret        
     }

     if (-Not $htable.ContainsKey($inputParam)) {
        $htable.Add($inputParam, $ret)    
        writeHashtable;
     }
     
     return $ret
}

readHashTable;

while ($true){ 
    Write-Host "Enter string UUID (ctrl+c to quit): " -ForegroundColor Green -NoNewline
    $script:inputParam = Read-Host   

    $rnd = GetRandomNumber
    $numericInputParam = '{0:X}' -f $rnd
    $numericInputParam = $numericInputParam.ToUpper();

    write-host "Copying generated value to clipboard: 0x$numericInputParam (uInt32: $rnd)"
    Set-Clipboard -Value "0x$numericInputParam"
}

