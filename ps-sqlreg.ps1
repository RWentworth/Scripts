# **********************************************
# *** DEVELOPED BY TREVOR BRYANT, PHACIL INC ***
# ***      ps-p1r.ps1 v1.0, 8/15/2014        ***
# ***  USER MUST EXECUTE AS ADMININISTRATOR  ***
# **********************************************

$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = Get-Content "C:\temp\hostlist"
$ErrorActionPreference="SilentlyContinue"

$mod = @("ActiveDirectory","Get-InstalledSoftware")
$mod | foreach { Import-Module $_ }

Write-Host "`nScanning ... "
$server | foreach { Write-Host "$_"
    $share = "C:\temp\ISSO\$_"
    $file = "$share\$_`_$timestamp.txt"
    $log = "$share\$_`_log.txt"
    $ErrorActionPreference="SilentlyContinue"
    
    if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }
   
    $user = whoami
    Write-Output "Executed by $user on device $_" | Out-File -Append $file
    
    gp HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where { $_.DisplayName -Like '*SQL*' } | FT -AutoSize DisplayName,Version,InstallLocation
    (gp HKLM:\SOFTWARE\Microsoft\ASP.NET\*).AssemblyVersion

}

$sqlserver = gc C:\temp\sqlhost
$sqlpath = @("C$\Microsoft SQL Server",
	"C$\Program Files\Microsoft SQL Server",
	"C$\Program Files (x86)\Microsoft SQL Server",
	"C$\Program Files (x86)\Microsoft SQL Server Compact Edition",
	"E$\Microsoft SQL Server",
	"E$\Program Files\Microsoft SQL Server",
	"E$\Program Files (x86)\Microsoft SQL Server",
	"F$\Microsoft SQL Server",
	"G$\Microsoft SQL Server",
	"H$\Microsoft SQL Server" )
#$sqlserver | Foreach { Foreach ($s in $sqlpath) { Get-ACL \\$_\$s -Audit } } | Format-List PSPath,AuditToString