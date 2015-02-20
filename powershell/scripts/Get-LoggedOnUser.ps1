#Requires -Version 2.0            
[CmdletBinding()]            
Param (                       
    [Parameter(Mandatory=$true,
               Position=0,                          
               ValueFromPipeline=$true,            
               ValueFromPipelineByPropertyName=$true)]            
    [String[]]$ComputerName)

Process            
{
    $ComputerName | Foreach-object {
		$Computer = $_
		try
        {
            $processinfo = @(Get-WmiObject -class win32_process -ComputerName $Computer -EA "Stop")
			if ($processinfo)
			{    
				$processinfo | Foreach-Object {$_.GetOwner().User} | 
					Where-Object {$_ -ne "NETWORK SERVICE" -and $_ -ne "LOCAL SERVICE" -and $_ -ne "SYSTEM"} |
					Sort-Object -Unique |
					ForEach-Object { New-Object psobject -Property @{Computer=$Computer;LoggedOn=$_} } | 
					Select-Object Computer,LoggedOn
			}
        }
		catch
        {
            Write-Error $_ -TargetObject $Computer
        }
    }           
}
