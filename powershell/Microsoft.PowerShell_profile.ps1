# This file is only executed by the full powershell console host (i.e. not visual studio, etc.)

# Execute newest visual studio command prompt batch file and 
Get-ChildItem Env: `
    | ? { $_.Name -match "VS\d+COMNTOOLS" } `
    | Sort-Object -Descending `
    | % { Join-Path $_.Value VsDevCmd.bat } `
    | ? { Test-Path $_ } `
    | Select-Object -First 1 `
    | % { Invoke-BatchFile $_ }