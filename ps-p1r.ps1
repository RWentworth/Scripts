# *** DEVELOPED BY TREVOR BRYANT, PHACIL INC ***
# *** ps-p1r.ps1 v1.0, 8/15/2014 ***
# *** USER MUST EXECUTE AS ADMININISTRATOR ***

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
    
    $IPa = [System.Net.DNS]::GetHostAddresses("$_")
    $AD = Get-ADComputer $_
    $Obj1 = New-Object -TypeName PSObject
    $Obj1 | Add-Member -MemberType noteproperty -name 'ComputerName' -value $_
    $Obj1 | Add-Member -MemberType noteproperty -name 'IP Address' -value $IPa[0].IPAddressToString
    $Obj1 | Add-Member -MemberType noteproperty -name 'AD Path' -value $AD.DistinguishedName
    $Obj1 | FL | Out-File -Append $file
          
    Get-InstalledSoftware $_ | FT -Autosize | Out-File -Append $file
    $error | Out-File $log
    $error.clear()
}
   
do { 
$job = Invoke-Expression -Command 'Get-Job -State "Running" | Select-Object State | Select-String -pattern "Running" -quiet'
Start-Sleep 5} while ($job -eq "True")
Remove-Job *
Write-Host "`nScanning complete"
Write-Host "Results saved: C:\temp\ISSO"
