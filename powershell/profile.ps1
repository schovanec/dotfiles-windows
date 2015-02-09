# Remember the location of the profile 
$ProfileRoot = $PSScriptRoot

# Import modules
Import-Module posh-git

# Make git output in colour
Enable-GitColors

# Add some directories to the path (if they exist)
@(
    # Add git installation to the path to give us access to SSH
    (Join-Path ${env:ProgramFiles(x86)} Git\bin),

    # Add our custom scripts directory to the path
    (Join-Path $ProfileRoot scripts)
) | ? { Test-Path $_ } | % { $env:PATH += ";$_" }

# Include other scripts
@(
    "aliases.ps1",
    "prompt.ps1",
    "local.ps1"
) | % { Join-Path $ProfileRoot $_ } | ? { Test-Path $_ } | % { . $_ }
