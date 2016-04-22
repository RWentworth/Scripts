# *** DEVELOPED BY TREVOR BRYANT, PHACIL INC ***
# *** ps-w2k8r2 v2.ps1 v00.00.03, 8/21/2014 ***
# *** USER MUST EXECUTE AS ADMININISTRATOR ***

$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = hostname
$share = "C:\temp\ISSO\$server\$server`_$timestamp"
$file = "$share\$server`_Oracle_$timestamp.txt"
$log = "$share\$server`_log_$timestamp.txt"
$sec = "$share\$server`_secedit_$timestamp.txt"
$ErrorActionPreference="SilentlyContinue"
$error.clear()

Write-Host "`nScanning $server ... "
if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }

# Oracle 10G: 25, 27, 33, 53 to 56.

$cmd = net localgroup Administrators
echo `n "25) The Oracle installation owner account shall be a member of the local Administrators group." $cmd | Out-file -Append $file

$cmd = net group /domain ORA_DBA
echo `n "27) The Oracle installation owner account shall be included in the ORA_DBA Windows security group." $cmd | Out-file -Append $file

echo `n "33) The database administrator security group shall be assigned the 'Allow Log on Locally' user right." | Out-file -Append $file
secedit /export /cfg $sec
cat $sec | Select-String -Pattern "SeInteractiveLogonRight" | Out-file -Append $file

echo `n "53) NTFS permissions on all Oracle Database 10g Release 2 operating system files shall be set to the following:" | Out-file -Append $file
$orapath = @("C:\Program Files\Oracle","E:\oracle")
$orapath | foreach { echo `n $_ ; (Get-Acl -Audit $_).AccessToString } | Out-file -Append $file

echo `n "54) All Oracle Database 10g Release 2 operating system files shall be audited within Windows 2003/2008 as follows:" | Out-file -Append $file
$orapath | foreach { echo `n $_ ; (Get-Acl -Audit $_).AuditToString } | Out-file -Append $file

echo `n "55) Permissions on all Oracle Database 10g Release 2 registry keys shall be set to the following:" | Out-file -Append $file
$orareg = @("HKLM:\SOFTWARE\ORACLE")
$orareg | foreach { echo `n $_ ; (Get-Acl -Audit $_).AccessToString } | Out-file -Append $file

echo `n "56) All Oracle Database 10g Release 2 registry keys shall be audited within Windows 2003/2008 as follows:" | Out-file -Append $file
$orareg | foreach { echo `n $_ ; (Get-Acl -Audit $_).AuditToString } | Out-file -Append $file

#find and replace SID to group name in secedit
$original_file = "$file"
$destination_file =  "$file"
(Get-Content $original_file) | Foreach-Object {
    $_ -replace 'S-1-1-0', 'Everyone' `
   -replace 'S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420', 'WdiServiceHost' `
   -replace 'S-1-5-32-544', 'Administrators' `
   -replace 'S-1-5-32-545', 'Users' `
   -replace 'S-1-5-32-546', 'Guests' `
   -replace 'S-1-5-32-551', 'Backup Operators' `
   -replace 'S-1-5-19', 'NT Authority' `
   -replace 'S-1-5-20', 'NT Authority' `
   -replace 'S-1-5-80-0', 'NT SERVICES\ALL SERVICES' `
   -replace 'S-1-5-80', 'NT Service' `
   -replace 'S-1-5-32-559', 'BUILTIN\Performance Log Users' `
   -replace 'S-1-5-6', 'Service' `
   -replace 'S-1-5-32-555', 'BUILTIN\Remote Desktop Users' `
   -replace 'S-1-5-32-568', 'IIS_IUSRS' `
 } | Set-Content $destination_file

$error | Out-File $log
$error.clear()
Write-Host "`nScanning $server complete"
Write-Host "Results saved: $file"`n