# Get a shortened verion of a path for display in the prompt
function Get-ShortPath([string] $path) {
    if ($path.StartsWith($home, "CurrentCultureIgnoreCase")) {
        "~{0}" -f $path.Substring($home.Length)
    }
    else {
        $path
    }
}

function Get-IsAdminUser() {
    $Principal = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent())
    $Principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

$global:PromptTheme = @{
    BaseColor = [ConsoleColor]::Gray
    PathColor = [ConsoleColor]::White
    NameColor = if (Get-IsAdminUser) { [ConsoleColor]::Red } else { [ConsoleColor]::Green }
    ForegroundColor = $Host.UI.RawUI.ForegroundColor
}

function prompt {
    $SavedExitCode = $LASTEXITCODE
    try {
        $UserName = [Environment]::UserName.ToLower()
        $HostName = [Environment]::MachineName.ToLower()
        $ShortPath = Get-ShortPath $pwd.ProviderPath

        $Host.UI.RawUI.ForegroundColor = $PromptTheme.ForegroundColor

        Write-Host '[' -NoNewLine -ForegroundColor $PromptTheme.BaseColor
        Write-Host "${UserName}@${HostName}" -NoNewLine -ForegroundColor $PromptTheme.NameColor
        Write-Host '] ' -NoNewLine -ForegroundColor $PromptTheme.BaseColor
        Write-Host $ShortPath -NoNewLine -ForegroundColor $PromptTheme.PathColor
        
        Write-VcsStatus

        Write-Host '>' -NoNewLine -ForegroundColor $PromptTheme.BaseColor
    }
    finally {
        $global:LASTEXITCODE = $SavedExitCode
    }

    return ' '
}
