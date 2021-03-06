# *** DEVELOPED BY TREVOR BRYANT, PHACIL INC ***
# *** ps-wincheck.ps1 v1.0, 8/15/2014 ***
# *** USER MUST EXECUTE AS ADMININISTRATOR ***

$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = Get-Content "C:\temp\hostlist"
$ErrorActionPreference="SilentlyContinue"

$mod = @("ActiveDirectory","Get-InstalledSoftware")
$mod | foreach { Import-Module $_ }

Write-Host "`nScanning ... "
$server | foreach { Write-Host "$_" }
$server | foreach {
    $share = "C:\temp\ISSO\$_"
    $file = "$share\$_`_$timestamp.txt"
    $log = "$share\$_`_log.txt"
    
    if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }
   
    $user = whoami
    Write-Output "Script executed by $user on device $_"`n | Out-File -Append "$file"
    
    $IPa = [System.Net.DNS]::GetHostAddresses("$_")
    $AD = Get-ADComputer $_ | Select-Object DistinguishedName
    $Object = New-Object -TypeName PSObject
    $Object | Add-Member -MemberType noteproperty -name 'ComputerName' -value $_
    $Object | Add-Member -MemberType noteproperty -name 'IP Address' -value $IPa[0].IPAddressToString
    $Object | Add-Member -MemberType noteproperty -name 'AD Path' -value $AD
    $Object | FL | Out-File -Append $file
    
    Get-InstalledSoftware $_ | FT -Autosize | Out-File -Append $file
    $error | Out-File $log
    $error.clear()
    } 
Write-Host "`nScanning complete"
Write-Host "Results saved: $share"