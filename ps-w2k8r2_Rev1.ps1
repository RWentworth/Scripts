# *** DEVELOPED BY TREVOR BRYANT, PHACIL INC ***
# *** ps-w2k8r2.ps1 version 1.0.1, 9/15/2014 ***
# ***  USER MUST EXECUTE AS ADMININISTRATOR  ***

$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = hostname
$share = "C:\temp\ISSO\$server\$server`_$timestamp"
$file = "$share\$server`_$timestamp.txt"
$iis = "$share\$server`_IIS_$timestamp.txt"
$log = "$share\$server`_log_$timestamp.txt"
$sec = "$share\$server`_secedit_$timestamp.txt"
$RSoP = "$share\$server`_RSoP_$timestamp.txt"
$ErrorActionPreference="SilentlyContinue"

Write-Host "`nScanning $server ... "
if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }

$user = whoami
Write-Output "Executed by $user on device $server" | Out-File -Append "$file"
$OSver = (gwmi Win32_OperatingSystem).Caption
Write-Output $OSver`n | Out-File -Append "$file"

Write-Output "DS Security Template(s) applied:" | Out-File -Append "$file"
gp "HKLM:\Software\DOS\Templates\*" | where { $_.Description -Like "*" } | FT -AutoSize Description,CurrentVer | Out-File -Append "$file"

Write-Output ".NET Framework Versions installed:" | Out-File -Append "$file"
ls $Env:windir\Microsoft.NET\Framework | ? { $_.PSIsContainer -and $_.Name -match '^v\d.[\d\.]+' } | % { $_.Name.TrimStart('v') } | Out-File -Append "$file"

#Check if IIS is running, get version, run checklist
if (Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue) {
    $ver = (gp "HKLM:\Software\Microsoft\InetStp").SetupString
        Write-Output "$ver is running on $server"`n | Out-File "$iis"
        switch -wildcard ($ver) {
            "IIS 6.0" { 
                Write-Output `n "$ver is running, review $iis"`n | Out-File -Append "$file"
                Write-Output "Manual verification needed"`n | Out-File -Append "$iis" }
            "IIS 7.*" { 
                Write-Output `n "$ver is running, review $iis"`n | Out-File -Append "$file"
                Write-Output "Manual verification needed"`n | Out-File -Append "$iis" }
            default { }
    }} else { Write-Output `n "IIS is not running on $server"`n | Out-File -Append "$file" }

Write-Output "Software installed:" | Out-File -Append "$file"
(gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*) | Sort DisplayName | FT -Autosize DisplayName,DisplayVersion | Out-File -Append "$file"

#Check Operating System and run checklist
Write-Output "Executing checklist for Operating System"`n | Out-File -Append "$file"
Switch ($OSver) {
    "Microsoft Windows 7 Enterprise " { Write-Output "Tailored for Windows 7 Enterprise Security Configuration Standard 2.1, 10/11/2013"`n | Out-File -Append "$file" 
    Write-Output "Work in progress" | Out-File -Append "$file" } 
    "Microsoft Windows Server 2008 R2 Enterprise " { Write-Output "Tailored for Windows Server 2008 Release 2 (Member Server) Security Configuration Standard 1.2 8/27/2012"`n | Out-File -Append "$file"

    Write-Output "1 & 2) [X] indicates installed." | Out-File -Append "$file"
    ServerManagerCmd -query | Select-Object -Skip 5 | Out-File -Append "$file"

    Write-Output `n "3) Finding if not set to 1" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableLua
    Write-Output "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLua = $cmd" | Out-File -Append "$file"

    Write-Output `n "4)" | Out-File -Append "$file"
    secedit /export /cfg $sec | Out-Null
    $cmd = cat $sec | Select-String -Pattern 'PasswordHistorySize ='
    Write-Output "Enforce Password History: $cmd" | Out-File -Append "$file"
    $cmd = cat $sec | Select-String -Pattern 'MaximumPasswordAge ='
    Write-Output "Maximum Password Age: $cmd" | Out-File -Append "$file"
    $cmd = cat $sec | Select-String -Pattern 'MinimumPasswordAge ='
    Write-Output "Minimum Password Age: $cmd" | Out-File -Append "$file"
    $cmd = cat $sec | Select-String -Pattern 'MinimumPasswordLength ='
    Write-Output "Minimum Password Length: $cmd" | Out-File -Append "$file"
    $cmd = cat $sec | Select-String -Pattern 'PasswordComplexity ='
    Write-Output "Passwords must meet complexity requirements: $cmd" | Out-File -Append "$file"
    $cmd = cat $sec | Select-String -Pattern 'ClearTextPassword ='
    Write-Output "Store passwords with reversible encrpytion: $cmd" | Out-File -Append "$file"

    Write-Output `n "5)" | Out-File -Append "$file"
    $cmd = cat $sec | Select-String -Pattern 'LockoutDuration ='
    Write-Output "Account lockout duration: $cmd" | Out-File -Append "$file"
    $cmd = cat $sec | Select-String -Pattern 'LockoutBadCount ='
    Write-Output "Account lockout threshold: $cmd" | Out-File -Append "$file"
    $cmd = cat $sec | Select-String -Pattern 'ResetLockoutCount ='
    Write-Output "Reset account lockout counter after: $cmd" | Out-File -Append "$file"

    Write-Output `n "6) Settings for 'No One' may not show below." | Out-File -Append "$file"
    cat $sec | Select-string -Pattern "S-1"| Out-File -Append "$file"

    Write-Output `n "7) Review the $RSoP" | Out-File -Append "$file"
    gpresult /Scope Computer /V >$RSoP

    Write-Output `n "8)" | Out-File -Append "$file"
    auditpol /get /category:"Account Logon" | Out-File -Append "$file"
    auditpol /get /category:"Account Management" | Out-File -Append "$file"
    auditpol /get /category:"Detailed Tracking" | Out-File -Append "$file"
    auditpol /get /category:"DS Access" | Out-File -Append "$file"
    auditpol /get /category:"Logon/Logoff" | Out-File -Append "$file"
    auditpol /get /category:"Object Access" | Out-File -Append "$file"
    auditpol /get /category:"Policy Change" | Out-File -Append "$file"
    auditpol /get /category:"Privilege Use" | Out-File -Append "$file"
    auditpol /get /category:"System" | Out-File -Append "$file"
    auditpol /get /category:"Global Object Access Auditing" | Out-File -Append "$file"

    Write-Output `n "9)" | Out-File -Append "$file"
    gwmi Win32_Service -Property * | FT -Autosize DisplayName,Startmode | Out-File -Append "$file"

    Write-Output `n "10) Review the $RSoP" | Out-File -Append "$file"

    Write-Output `n "11) No value indicates no value set or the key does not exist" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\Software\JavaSoft\Java Update\Policy").EnableAutoUpdateCheck
    Write-Output "HKLM:\Software\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck: $cmd" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\Software\JavaSoft\Java Update\Policy").EnableJavaUpdate
    Write-Output "HKLM:\Software\JavaSoft\Java Update\Policy\EnableJavaUpdate: $cmd" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\Software\JavaSoft\Java Update\Policy" ).EnableAutoUpdateCheck
    Write-Output "HKCU:\Software\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck: $cmd" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SunJavaUpdateSched").SunJavaUpdateSched
    Write-Output "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SunJavaUpdateSched (remove entry): $cmd"  | Out-File -Append "$file"
    $cmd = (gp "HKLM:\SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{5852F5ED-8BF4-11D4-A245-0080C6F74284}") | Select-String -pattern "Flags"
    Write-Output "HKLM:\SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{5852F5ED-8BF4-11D4-A245-0080C6F74284}: $cmd" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters").DisabledComponents
    Write-Output "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\DisabledComponents: $cmd" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\Software\Policies\Microsoft\SystemCertificates\Root\ProtectedRoots").Flags
    Write-Output "HKLM:\Software\Policies\Microsoft\SystemCertificates\Root\ProtectedRoots: $cmd" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems").Posix
    Write-Output "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems\Posix (remove entry): $cmd" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems").Optional
    Write-Output "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems\Optional (remove entry): $cmd" | Out-File -Append "$file"
    $cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion").ShellServiceObjectDelayLoad
    Write-Output "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad (remove entry): $cmd" | Out-File -Append "$file"
    }
    default { Write-Output "Case statement did not execute checklist verification."`n | Out-File -Append "$file" }
}

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