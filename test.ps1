$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = Get-Content "C:\temp\hostlist"
$ErrorActionPreference="SilentlyContinue"

$mod = @("ActiveDirectory","Get-InstalledSoftware")
$mod | foreach { Import-Module $_ }

echo "`nScanning ... "
$server | foreach { Write-Host "$_"
    $share = "C:\temp\ISSO\$_"
    $file = "$share\$_`_$timestamp.csv"
    $log = "$share\$_`_log.txt"
    $ErrorActionPreference="SilentlyContinue"
    
    if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }
    
    $results = @()
    
    $user = whoami
   # write-output "Executed by $user on device $_" | Export-CSV -NoClobber $file
    
    $IPa = [System.Net.DNS]::GetHostAddresses("$_")
    $AD = Get-ADComputer $_
        
    $Object = New-Object -TypeName PSObject
    $Object | Add-Member -MemberType noteproperty -name 'ComputerName' -value $_
    $Object | Add-Member -MemberType noteproperty -name 'IP Address' -value $IPa[0].IPAddressToString
    $Object | Add-Member -MemberType noteproperty -name 'AD Path' -value $AD.DistinguishedName
    $Object | Add-Member -MemberType noteproperty -name 'Software' -value $SW
    $results += $Object
    $results | Export-CSV $file -NoTypeInformation
    
#    Get-InstalledSoftware $_ | Export-CSV -NoClobber $file -NoTypeInformation
} 
   
do { 
$job = Invoke-Expression -Command 'Get-Job -State "Running" | Select-Object State | Select-String -pattern "Running" -quiet'
Start-Sleep 5} while ($job -eq "True")
Remove-Job *
Write-Host "`nScanning complete"
Write-Host "Results saved: $file"