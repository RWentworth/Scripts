# *** DEVELOPED BY TREVOR BRYANT, PHACIL INC ***
# *** ps-w2k8r2.ps1 version 1.0.2, 4/6/2015 ***
# ***  USER MUST EXECUTE AS ADMININISTRATOR  ***

Write-Output "DS Security Template(s) applied:"
gp "HKLM:\Software\DOS\Templates\*" | where { $_.Description -Like "*" } | FT -AutoSize Description,CurrentVer

Write-Output ".NET Framework Versions installed:"
ls $Env:windir\Microsoft.NET\Framework | ? { $_.PSIsContainer -and $_.Name -match '^v\d.[\d\.]+' } | % { $_.Name.TrimStart('v') }

Write-Output "Software installed:"
(gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*) | Sort DisplayName | FT -Autosize DisplayName,DisplayVersion

Import-Module ServerManager

Write-Output "1 & 2) [X] indicates installed."
Get-WindowsFeature | where { $_.Installed -eq 'True' } | FT -Autosize | Out-String
Write-Output `n "3) Finding if not set to 1"
$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableLua
Write-Output "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLua = $cmd"
Write-Output `n "4)"
secedit /export /cfg $sec | Out-Null
$cmd = cat $sec | Select-String -Pattern 'PasswordHistorySize ='
Write-Output "Enforce Password History: $cmd"
$cmd = cat $sec | Select-String -Pattern 'MaximumPasswordAge ='
Write-Output "Maximum Password Age: $cmd"
$cmd = cat $sec | Select-String -Pattern 'MinimumPasswordAge ='
Write-Output "Minimum Password Age: $cmd"
$cmd = cat $sec | Select-String -Pattern 'MinimumPasswordLength ='
Write-Output "Minimum Password Length: $cmd"
$cmd = cat $sec | Select-String -Pattern 'PasswordComplexity ='
Write-Output "Passwords must meet complexity requirements: $cmd"
$cmd = cat $sec | Select-String -Pattern 'ClearTextPassword ='
Write-Output "Store passwords with reversible encrpytion: $cmd"
Write-Output `n "5)"
$cmd = cat $sec | Select-String -Pattern 'LockoutDuration ='
Write-Output "Account lockout duration: $cmd minutes"
$cmd = cat $sec | Select-String -Pattern 'LockoutBadCount ='
Write-Output "Account lockout threshold: $cmd attempts"
$cmd = cat $sec | Select-String -Pattern 'ResetLockoutCount ='
Write-Output "Reset account lockout counter after: $cmd minutes"

Write-Output `n "6) Settings for 'No One' may not show below."
cat $sec | Select-string -Pattern "S-1"| Out-File -Append "$file"

Write-Output `n "7) Review the $RSoP"
gpresult /Scope Computer /V >$RSoP

Write-Output `n "8)"
auditpol /get /category:* 

Write-Output `n "9)"
gwmi Win32_Service -Property * | FT -Autosize DisplayName,Startmode

Write-Output `n "10) Review the $RSoP"

Write-Output `n "11) No value indicates no value set or the key does not exist"
$cmd = (gp "HKLM:\Software\JavaSoft\Java Update\Policy").EnableAutoUpdateCheck
Write-Output "HKLM:\Software\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck: $cmd"
$cmd = (gp "HKLM:\Software\JavaSoft\Java Update\Policy").EnableJavaUpdate
Write-Output "HKLM:\Software\JavaSoft\Java Update\Policy\EnableJavaUpdate: $cmd"
$cmd = (gp "HKCU:\Software\JavaSoft\Java Update\Policy").EnableAutoUpdateCheck
Write-Output "HKCU:\Software\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck: $cmd"
$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SunJavaUpdateSched").SunJavaUpdateSched
Write-Output "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SunJavaUpdateSched (remove entry): $cmd" 
$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{5852F5ED-8BF4-11D4-A245-0080C6F74284}") | Select-String -pattern "Flags"
Write-Output "HKLM:\SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{5852F5ED-8BF4-11D4-A245-0080C6F74284}: $cmd"
$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters").DisabledComponents
Write-Output "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\DisabledComponents: $cmd"
$cmd = (gp "HKLM:\Software\Policies\Microsoft\SystemCertificates\Root\ProtectedRoots").Flags
Write-Output "HKLM:\Software\Policies\Microsoft\SystemCertificates\Root\ProtectedRoots: $cmd"
$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems").Posix
Write-Output "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems\Posix (remove entry): $cmd"
$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems").Optional
Write-Output "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems\Optional (remove entry): $cmd"
$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion").ShellServiceObjectDelayLoad
Write-Output "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad (remove entry): $cmd"

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
  