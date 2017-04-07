# This file is only executed by the full powershell console host (i.e. not visual studio, etc.)

# Import modules
Import-Module posh-git

# Make git output in colour
Enable-GitColors

# Execute newest visual studio command prompt batch file and
Invoke-VsEnvironment

# Include other scripts
@(
    "aliases.ps1",
    "prompt.ps1",
    "local.ps1"
) | % { Join-Path $ProfileRoot $_ } | ? { Test-Path $_ } | % { . $_ }
