# *** DEVELOPED BY TREVOR BRYANT, PHACIL INC ***
# *** ps-isso.ps1 version 1.0.0, 4/6/2015 ***
# ***  USER MUST EXECUTE AS ADMININISTRATOR  ***

$timestamp=(Get-Date -f HHmmss_MMddyyyy)
$server = hostname
$share = "C:\temp\ISSO\$server\$server`_$timestamp"
$win2k8r2 = "$share\$server`_OS_$timestamp.txt"
$iis = "$share\$server`_IIS_$timestamp.txt"
$log = "$share\$server`_log_$timestamp.txt"
$sec = "$share\$server`_secedit_$timestamp.txt"
$RSoP = "$share\$server`_RSoP_$timestamp.txt"
$ErrorActionPreference="SilentlyContinue"

Write-Host "`nScanning $server ... "
if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }

#DETERMINE OS VERSION AND CALL SCRIPT
	$OS = (gwmi Win32_OperatingSystem).Caption
    switch -wildcard ($OS) {
		"2003" { ECHO "$OS$OSver" }
		"Microsoft Windows 7 Enterprise " { Write-Host "Manual verification required for WIn 7" }
		"Microsoft Windows Server 2008 R2 Enterprise " { Write-Host "Calling Win2K8 R2 script"; & C:\ps-scripts\ps-w2k8r2.ps1 > $win2k8r2 }
        default { echo "Not verified" }
    }

#IF IIS SERVICE IS RUNNING, DETERMINE IIS VERSION AND CALL SCRIPT
if (Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue) {
    $ver = (gp "HKLM:\Software\Microsoft\InetStp").SetupString
        switch -wildcard ($ver) {
            "IIS 6.0" { Write-Host "Manual verification required for IIS 6.0" }
            "IIS 7.*" { Write-Host "Calling IIS 7.0/7.5 script"; & C:\ps-scripts\ps-iis.ps1 > $iis }
            default { }
    }} else { Write-Output `n "IIS is not running on $server"`n | Out-File -Append "$iis" }

#REMOVE SCRIPTS AFTER SCANS COMPLETE
Write-Host "Cleaning ..."
Set-Content "C:\ps-scripts\cleanup.ps1" -Value "Remove-Item -Force -Recurse C:\ps-scripts\*"; & C:\ps-scripts\cleanup.ps1


$error | Out-File $log
$error.clear()
Write-Host "Scanning $server complete"
Write-Host "Results saved: $share"`n