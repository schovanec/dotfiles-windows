$dotfilesRoot = Split-Path $PSScriptRoot
$documentsPath = [Environment]::GetFolderPath('Personal')
$gitHome = If ($env:HOME -ne $null) { $env:HOME } Else { "~" }

Import-Module (Join-Path $dotfilesRoot powershell\modules\mklink)

# link powershell profile directory
New-SymLink (Join-Path $documentsPath WindowsPowerShell) (Join-Path $dotfilesRoot powershell) -Directory

# link git config files
Get-ChildItem (Join-Path $dotfilesRoot git) -Filter .* | % { New-SymLink (Join-Path $gitHome $_.Name) $_.FullName -File }
