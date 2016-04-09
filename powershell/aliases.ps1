# alias for ssh
Join-Path ${env:ProgramFiles} "Git\usr\bin\ssh.exe" | ? { Test-Path $_ } | % { Set-Alias ssh $_ }
