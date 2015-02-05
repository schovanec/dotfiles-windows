$dotfilesRoot = Split-Path $PSScriptRoot
$documentsPath = [Environment]::GetFolderPath('Personal')

Import-Module (Join-Path $dotfilesRoot powershell\modules\mklink)

# link powershell profile directory
New-SymLink (Join-Path $documentsPath WindowsPowerShell) (Join-Path $dotfilesRoot powershell) -Directory

# link sublime text directory
New-SymLink (Join-Path ${env:APPDATA} "Sublime Text 3") (Join-Path $dotfilesRoot sublime-text) -Directory

# link git config files
Get-ChildItem (Join-Path $dotfilesRoot git) -Filter .* | % { New-SymLink (Join-Path ~ $_.Name) $_.FullName -File }