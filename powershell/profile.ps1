# Remember the location of the profile 
$ProfileRoot = $PSScriptRoot

# Create an alias for launching the Sublime Text Editor
Set-Alias subl (Join-Path ${env:ProgramFiles} "Sublime Text 3\subl.exe")

# Import modules
Import-Module posh-git

# Make git output in colour
Enable-GitColors

# Add git installation to the path to give us access to SSH
Join-Path ${env:ProgramFiles(x86)} Git\bin | ? { Test-Path $_ } | % { $env:PATH += ";$_" }

# Add our custom scripts directory to the path
Join-Path $ProfileRoot scripts | ? { Test-Path $_ } | % { $env:PATH += ";$_" }

# Include other scripts
@(
    "aliases.ps1",
    "prompt.ps1"
) | % { Join-Path $ProfileRoot $_ } | ? { Test-Path $_ } | % { . $_ }
