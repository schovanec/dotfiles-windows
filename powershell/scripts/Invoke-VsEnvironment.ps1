$completed = $false

# Attempt to find VS2017 or newer
if ([bool](Get-Command -Name vswhere -ErrorAction SilentlyContinue)) {
    $vsInstallPath = (vswhere -latest -format json | ConvertFrom-Json).installationPath
    $vsBatchFile = Join-Path $vsInstallPath "Common7\Tools\VsDevCmd.bat"
    if (Test-Path $vsBatchFile) {
        Invoke-BatchFile $vsBatchFile $(if ([Environment]::Is64BitProcess) {'-arch=amd64'} else {'-arch=x86'})
        $completed = $true
    }
}

if (-not $completed) {
    Get-ChildItem Env: `
        | ? { $_.Name -match "VS\d+COMNTOOLS" } `
        | Sort-Object -Descending `
        | % { Join-Path $_.Value VsDevCmd.bat } `
        | ? { Test-Path $_ } `
        | Select-Object -First 1 `
        | % { Invoke-BatchFile $_ $(if ([Environment]::Is64BitProcess) {'amd64'} else {'x86'}) }
}