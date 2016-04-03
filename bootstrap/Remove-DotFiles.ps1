$dotfilesRoot = Split-Path $PSScriptRoot
$documentsPath = [Environment]::GetFolderPath('Personal')

Import-Module (Join-Path $dotfilesRoot powershell\modules\mklink)

@(
    # powershell profile
    (Join-Path $documentsPath WindowsPowerShell),

    # git configuration files
    (Get-ChildItem (Join-Path $dotfilesRoot git) -Filter .* | % { Join-Path ~ $_.Name })

) | ? { Test-ReparsePoint -LiteralPath $_ } | % { Remove-ReparsePoint -LiteralPath $_ }
