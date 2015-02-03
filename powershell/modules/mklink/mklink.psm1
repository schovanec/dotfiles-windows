
function GetNativeMethods {
    Add-Type -PassThru -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;
        namespace MkLink {
            public class NativeMethods {
                [DllImport("kernel32.dll", SetLastError=true, EntryPoint = "CreateSymbolicLink", CharSet = CharSet.Unicode)]
                private static extern bool NativeCreateSymbolicLink(string lpSymlinkFileName, string lpTargetFileName, int dwFlags);

                public static void CreateSymbolicLink(string lpSymlinkFileName, string lpTargetFileName, int dwFlags) 
                {
                    if (!NativeCreateSymbolicLink(lpSymlinkFileName, lpTargetFileName, dwFlags)) {
                        throw new System.ComponentModel.Win32Exception(); 
                    }
                }

                [DllImport("kernel32.dll", SetLastError = true, EntryPoint = "RemoveDirectory", CharSet = CharSet.Unicode)]
                private static extern bool NativeRemoveDirectory(string lpPathName);

                public static void RemoveDirectory(string lpPathName) 
                {
                    if (!NativeRemoveDirectory(lpPathName)) {
                        throw new System.ComponentModel.Win32Exception(); 
                    }
                }

                [DllImport("kernel32.dll", SetLastError = true, EntryPoint = "DeleteFile", CharSet = CharSet.Unicode)]
                private static extern bool NativeDeleteFile(string lpFileName);

                public static void DeleteFile(string lpFileName) 
                {
                    if (!NativeDeleteFile(lpFileName)) {
                        throw new System.ComponentModel.Win32Exception(); 
                    }
                }
            }
        }
"@
}

function New-Symlink {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param (
        [Alias("Path")]
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LiteralPath,

        [Alias("Target", "PSPath")]
        [Parameter(Position = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TargetPath,

        [Parameter(Position = 2, ParameterSetName = "File")]
        [switch]$File,

        [Parameter(Position = 2, ParameterSetName = "Directory")]
        [switch]$Directory
    )

    Begin {
        $Native = GetNativeMethods
    }
    Process {
        If (Test-Path $TargetPath -PathType Container) { $Flags = 1 } Else { $Flags = 0 }

        $AbsoluteLiteralPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($LiteralPath)

        $Flags = @{File = 0; Directory = 1}[$PSCmdLet.ParameterSetName]
        If ($PSCmdLet.ShouldProcess($TargetPath, "New symbolic link via $LiteralPath")) {
            Try {
                $Native::CreateSymbolicLink($AbsoluteLiteralPath, $TargetPath, $Flags)

                [PSCustomObject]@{
                    PSTypeName = "MkLink.SymbolicLink"
                    Link = $LiteralPath
                    Target = $TargetPath
                    Type = $PSCmdLet.ParameterSetName
                }
            }
            Catch [ComponentModel.Win32Exception] {
                Write-Error $_ -TargetObject $LiteralPath
            }
        }
    }
}

function Remove-ReparsePoint {
    [CmdletBinding(DefaultParameterSetName = "Path", SupportsShouldProcess = $true, ConfirmImpact = "High")]
    Param (
        [Parameter(ParameterSetName = "Path", Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Path,

        [Parameter(ParameterSetName = "LiteralPath", Position = 0, Mandatory = $true, ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
        [string[]]$LiteralPath
    )

    Begin {
        $Native = GetNativeMethods
    }
    Process {
        If ($PSCmdlet.ParameterSetName -eq "Path") {
            $items = Get-Item -Path $Path
        }
        Else {
            $items = Get-Item -LiteralPath $LiteralPath
        }

        ForEach ($item in $items) {
            If ($PSCmdLet.ShouldProcess($item, "Remove reparse point")) {
                Try {
                    If (-not $item.Attriutes -band [IO.FileAttributes]::ReparsePoint) {
                        Write-Error "The item is not a reparse point" -TargetObject $item
                    }
                    ElseIf ($item.Attributes -band [IO.FileAttributes]::Directory) {
                        $Native::RemoveDirectory($item)
                    }
                    Else {
                        $Native::DeleteFile($item)
                    }
                }
                Catch [ComponentModel.Win32Exception] {
                    Write-Error $_ -TargetObject $item
                }
            }
        }
    }
}

Export-ModuleMember New-Symlink, Remove-ReparsePoint