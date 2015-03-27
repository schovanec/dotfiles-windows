# Remember the location of the profile 
$ProfileRoot = $PSScriptRoot


# Add some directories to the path (if they exist)
@(
    # Add git installation to the path to give us access to SSH
    (Join-Path ${env:ProgramFiles(x86)} Git\bin),

    # Add our custom scripts directory to the path
    (Join-Path $ProfileRoot scripts)
) | ? { Test-Path $_ } | % { $env:PATH += ";$_" }
