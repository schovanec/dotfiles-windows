# This file is only executed by the full powershell console host (i.e. not visual studio, etc.)

# Import modules
Import-Module posh-git

# Enabled "Solarized" Colors
#Set-SolarizedDarkColorDefaults

# Make git output in colour
Enable-GitColors

# Set local for git and other unix commands
$env:LC_ALL = "C.UTF-8"

# Execute newest visual studio command prompt batch file and
Invoke-VsEnvironment

# Include other scripts
@(
    "aliases.ps1",
    "prompt.ps1",
    "local.ps1"
) | % { Join-Path $ProfileRoot $_ } | ? { Test-Path $_ } | % { . $_ }
