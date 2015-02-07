[CmdletBinding()]
Param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$File, 

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    $Parameters
)

cmd /c " `"$File`" $Parameters && set " | ForEach {
    If ($_ -match "^(.*?)=(.*)$") {
        Set-Content "Env:$($matches[1])" $matches[2]
    }
}