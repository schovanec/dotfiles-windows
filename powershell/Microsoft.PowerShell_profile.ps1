# This file is only executed by the full powershell console host (i.e. not visual studio, etc.)

# Execute newest visual studio command prompt batch file and 
Get-ChildItem Env: `
    | ? { $_.Name -match "VS\d+COMNTOOLS" } `
    | Sort-Object -Descending `
    | % { Join-Path $_.Value ..\..\VC\vcvarsall.bat } `
    | ? { Test-Path $_ } `
    | Select-Object -First 1 `
    | % { Invoke-BatchFile $_ $(if ([Environment]::Is64BitProcess) {'amd64'} else {'x86'}) }