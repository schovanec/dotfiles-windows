# alias for starting sublime text
Join-Path ${env:ProgramFiles} "Sublime Text 3\subl.exe" | ? { Test-Path $_ } | % { Set-Alias subl $_ }