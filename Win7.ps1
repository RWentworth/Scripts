$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = hostname
$share = "C:\temp\ISSO\$server"
$file = "$share\$server`_$timestamp.txt"
$log = "$share\$server`_log.txt"
$ErrorActionPreference="SilentlyContinue"
$name= (Get-Item Env:\COMPUTERNAME).value
$computerSystem = Get-CimInstance CIM_ComputerSystem
$computerBIOS = Get-CimInstance CIM_BIOSElement
$computerOS = Get-CimInstance CIM_OperatingSystem
$computerCPU = Get-CimInstance CIM_Processor
$computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"
Clear-Host


Write-Host "Scanning $server ... "
if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }

$user = whoami

Write-Output "Script executed by $user"`n | Out-File "$file"


Write-Output "PLEASE NOTE THE VALUES OF THE OUTPUT : TRUE = INSTALLED ; FALSE = NOT INSTALLED" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

Write-Output "#4 Only hardware listed on the IRM approved Hardware List shall be used with a computer running Windows 7:"| Out-File -Append "$file"
"Manufacturer: " + $computerSystem.Manufacturer | Out-File -Append "$file"
"Model: " + $computerSystem.Model | Out-File -Append "$file"
"Serial Number: " + $computerBIOS.SerialNumber | Out-File -Append "$file"
"CPU: " + $computerCPU.Name | Out-File -Append "$file"
"HDD Capacity: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB" | Out-File -Append "$file"
"HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)" | Out-File -Append "$file"
"RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB" | Out-File -Append "$file"
"Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (Get-UiCulture).DisplayName
Write-Output "#11 The workstation shall have a regional language set to U.S: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

Write-Output "#12 All Windows 7 workstations shall follow the approved standard naming convention: $name" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd1 = (gp 'HKLM:\SOFTWARE\Symantec\Symantec Endpoint Protection\CurrentVersion').'ProductName'
$cmd2 = (gp 'HKLM:\SOFTWARE\Symantec\Symantec Endpoint Protection\SMC').'ProductVersion'
Write-Output "#14 Virus-scanning software with the latest virus definitions shall be installed: $cmd1 $cmd2" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

Write-Output "#15 Only ITCCB approved versions of the Microsoft .NET framework shall be installed:" |  Out-File -Append "$file"
ls $Env:windir\Microsoft.NET\Framework | ? { $_.PSIsContainer -and $_.Name -match '^v\d.[\d\.]+' } | % { $_.Name.TrimStart('v') } | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableLUA
If ($cmd -eq 1) 
    {Write-Output "#16 User Account Control Enabled and set to Always Notify: ENABLED" | Out-File -Append "$file"}   
elseif ($cmd -eq 0) 
    {Write-Output "#16 User Account Control Enabled and set to Always Notify: DISABLED " | Out-File -Append "$file"}    
Write-Output `n | Out-File -Append "$file"


$cmd = test-path "C:\Program Files\Microsoft Games"
Write-Output "#17 Games: Not Installed: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "HKLM\SYSTEM\CurrentControlSet\Services\W3Svc\DisplayName"
Write-Output "#18 Internet Information Services Not Installed: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "HKLM\SYSTEM\CurrentControlSet\Services\simptcp\DisplayName"
Write-Output "#19 SimpleTCP Services Not Installed: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "C:\Windows\system32\telnet.exe"
Write-Output "#20 Telnet Client Not Installed: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "HKLM\SYSTEM\CurrentControlSet\Services"
Write-Output "#21 Telnet Server Not Installed: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "C:\Windows\system32\tftp.exe"
Write-Output "#22 TFTP Client Not Installed: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "C:\Windows\ehome\ehshell.exe"
Write-Output "#23 Windows Media Center Not Installed: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").LimitBlankPasswordUse
If ($cmd -eq 1)
    {Write-Output "#79 Accounts: Limit local account use of blank passwords to console logon only: ENABLED"  | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#79 Accounts: Limit local account use of blank passwords to console logon only: DISABLED"  | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").AuditBaseObjects
If ($cmd -eq 1)
    {Write-Output "#82 Audit: Audit the access of global system objects: ENABLED"  |  Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#82 Audit: Audit the access of global system objects: DISABLED"  |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").FullPrivilegeAuditing
If ($cmd -eq 1)
    {Write-Output "#83 Audit: Audit the use of Backup and Restore privilege: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#83 Audit: Audit the use of Backup and Restore privilege: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").SCENoApplyLegacyAuditPolicy
If ($cmd -eq 1) 
    {Write-Output "#84 Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#84 Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings: DIABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").SCENoApplyLegacyAuditPolicy
If ($cmd -eq 1)
    {Write-Output "#85 Audit: Shut down system immediately if unable to log security audits: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#85 Audit: Shut down system immediately if unable to log security audits: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").'undockwithoutlogon'
If ($cmd -eq 1)
    {Write-Output "#86 Devices: Allow undock without having to log on: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#86 Devices: Allow undock without having to log on: DISABLED"| Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").AllocateDASD
If ($cmd -eq 1)
    {Write-Output "#87 Devices: Allowed to format and eject removable media: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#87 Devices: Allowed to format and eject removable media: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers").AddPrinterDrivers
If ($cmd -eq 1)
    {Write-Output "#88 Devices: Prevent users from installing printer drivers: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#88 Devices: Prevent users from installing printer drivers: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").AllocateCDRoms
If ($cmd -eq 1)
    {Write-Output "#89 Devices: Restrict CD-ROM access to locally logged-on user only: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#89 Devices: Restrict CD-ROM access to locally logged-on user only: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").AllocateFloppies 
If ($cmd -eq 1)
    {Write-Output "#90 Devices: Restrict floppy access to locally logged-on user only: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#90 Devices: Restrict floppy access to locally logged-on user only: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").RequireSignOrSeal
If ($cmd -eq 1)
    {Write-Output "#91 Domain member: Digitally encrypt or sign secure channel data (always): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#91 Domain member: Digitally encrypt or sign secure channel data (always): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").SealSecureChannel 
If ($cmd -eq 1)
    {Write-Output "#92 Domain member: Digitally encrypt secure channel data (when possible): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#92 Domain member: Digitally encrypt secure channel data (when possible): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").SignSecureChannel
If ($cmd -eq 1)
    {Write-Output "#93 Domain member: Digitally sign secure channel data (when possible): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#93 Domain member: Digitally sign secure channel data (when possible): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").DisablePasswordChange
If ($cmd -eq 1)
    {Write-Output "#94 Domain member: Disable machine account password changes: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#94 Domain member: Disable machine account password changes: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").MaximumPasswordAge
Write-Output "#95 Domain member: Maximum machine account password age: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").RequireStrongKey
If ($cmd -eq 1)
    {Write-Output "#96 Domain member: Require strong (Windows 2000 or later) session key: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#96 Domain member: Require strong (Windows 2000 or later) session key: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").DontDisplayLockedUserID
If ($cmd -eq 1)
    {Write-Output "#97 Interactive logon: Display user information when session is locked: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#97 Interactive logon: Display user information when session is locked: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").DontDisplayLastUserName
If ($cmd -eq 1)
    {Write-Output "#98 Interactive logon: Do not display last user name: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#98 Interactive logon: Do not display last user name: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").DisableCAD
If ($cmd -eq 1)
    {Write-Output "#99 Interactive logon: Do not require CTRL+ALT+DELETE: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#99 Interactive logon: Do not require CTRL+ALT+DELETE: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").LegalNoticeText
Write-Output "#100 Interactive logon: Message text for users attempting to logon: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").LegalNoticeCaption
Write-Output "#101 Interactive logon: Message title for users attempting to logon: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").CachedLogonsCount
Write-Output "#102 Interactive logon: Number of previous logons to cache (in case domain controller is not available): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").PasswordExpiryWarning
Write-Output "#103 Interactive logon: Prompt user to change password before expiration: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").ForceUnlockLogon
If ($cmd -eq 1)
    {Write-Output "#104 Interactive logon: Prompt user to change password before expiration: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#104 Interactive logon: Prompt user to change password before expiration: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").ScRemoveOption
If ($cmd -eq 1)
    {Write-Output "#105 Interactive logon: Smart card removal behavior: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#105 Interactive logon: Smart card removal behavior: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters").RequireSecuritySignature
If ($cmd -eq 1)
    {Write-Output "#106 Microsoft network client: Digitally sign communications (always): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#106 Microsoft network client: Digitally sign communications (always): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters").EnableSecuritySignature
If ($cmd -eq 1)
    {Write-Output "#107 Microsoft network client: Digitally sign communications (if server agrees): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#107 Microsoft network client: Digitally sign communications (if server agrees): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters").EnablePlainTextPassword
If ($cmd -eq 1)
    {Write-Output "#108 Microsoft network client: Send unencrypted password to third-party SMB servers: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#108 Microsoft network client: Send unencrypted password to third-party SMB servers: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").AutoDisconnect 
Write-Output "#109 Microsoft network server: Amount of idle time required before suspending session: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").RequireSecuritySignature
If ($cmd -eq 1)
    {Write-Output "#110 Microsoft network server: Digitally sign communications (always): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#110 Microsoft network server: Digitally sign communications (always): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").EnableSecuritySignature
If ($cmd -eq 1)
    {Write-Output "#111 Microsoft network server: Digitally sign communications (if client agrees):  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#111 Microsoft network server: Digitally sign communications (if client agrees):  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").EnableForcedLogOff 
If ($cmd -eq 1)
    {Write-Output "#112 Microsoft network server: Disconnect clients when logon hours expire:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#112 Microsoft network server: Disconnect clients when logon hours expire:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").SMBServerNameHardeningLevel 
If ($cmd -eq 1)
    {Write-Output "#113 Microsoft network server: Server SPN target name validation level: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#113 Microsoft network server: Server SPN target name validation level: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").AutoAdminLogon
If ($cmd -eq 1)
    {Write-Output "#114 Enable Automatic Logon (Not Recommended): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#114 Enable Automatic Logon (Not Recommended): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters").DisableIPSourceRouting 
Write-Output "#115 MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing): $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").DisableIPSourceRouting 
Write-Output "#116 MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing): $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").EnableICMPRedirect
If ($cmd -eq 1)
    {Write-Output "#117 MSS: (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#117 MSS: (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Lanmanserver\Parameters").Hidden
If ($cmd -eq 1)
    {Write-Output "#118 MSS: (Hidden) Hide computer from the browse list (Not Recommended except for highly secure environments:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#118 MSS: (Hidden) Hide computer from the browse list (Not Recommended except for highly secure environments: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").KeepAliveTime
Write-Output "#119 MSS: (KeepAliveTime) How often keep-alive packets are sent in milliseconds: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\IPSEC").NoDefaultExempt
If ($cmd -eq 1)
    {Write-Output "#120 MSS: (NoDefaultExempt) Configure IPSec exemptions for various types of network traffic:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#120 MSS: (NoDefaultExempt) Configure IPSec exemptions for various types of network traffic: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netbt\Parameters").NoNameReleaseOnDemand
If ($cmd -eq 1)
    {Write-Output "#121 MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#121 MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").PerformRouterDiscovery
If ($cmd -eq 1)
    {Write-Output "#122 MSS: (PerformRouterDiscovery) Allow IRDP to detect and configure DefaultGateway addresses (could lead to DoS): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#122 MSS: (PerformRouterDiscovery) Allow IRDP to detect and configure DefaultGateway addresses (could lead to DoS): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager").SafeDllSearchMode 
If ($cmd -eq 1)
    {Write-Output "#123 MSS: (SafeDLLSearchMode) Enable safe DLL search mode (Recommended): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#123 MSS: (SafeDLLSearchMode) Enable safe DLL search mode (Recommended): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").ScreenSaverGracePeriod
Write-Output "#124 MSS: (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires (0 Recommended): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters").TcpMaxDataRetransmissions
Write-Output "#125 MSS: (TcpMaxDataRetransmissions IPv6) How many times unacknowledged data is retransmitted (3 recommended, 5 is default): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").TcpMaxDataRetransmissions 
Write-Output "#126 MSS: (TCPMaxDataRetransmissions) How many times unacknowledged data is retransmitted (3 Recommended, 5 is Default): $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Eventlog\Security").WarningLevel
Write-Output "#127 MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").RestrictAnonymousSAM
If ($cmd -eq 1)
    {Write-Output "#129 Network access: Do not allow anonymous enumeration of SAM accounts: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#129 Network access: Do not allow anonymous enumeration of SAM accounts: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").RestrictAnonymous
If ($cmd -eq 1)
    {Write-Output "#130 Network access: Do not allow anonymous enumeration of SAM accounts and shares: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#130 Network access: Do not allow anonymous enumeration of SAM accounts and shares: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").DisableDomainCreds
If ($cmd -eq 1)
    {Write-Output "#131 Network access: Do not allow storage of passwords and credentials for network authentication: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#131 Network access: Do not allow storage of passwords and credentials for network authentication: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").everyoneincludesanonymous
If ($cmd -eq 1)
    {Write-Output "#132 Network access: Let Everyone permissions apply to anonymous users: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#132 Network access: Let Everyone permissions apply to anonymous users: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters").NullSessionPipes

Write-Output "#133 Network access: Named Pipes that can be accessed anonymously: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths").Machine
Write-Output "#134 Network access: Remotely accessible registry paths: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedPaths").Machine
Write-Output "#135 Network access: Remotely accessible registry paths and subpaths: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters").restrictnullsessaccess 
If ($cmd -eq 1)
    {Write-Output "#136 Network access: Restrict anonymous access to Named Pipes and Shares: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#136 Network access: Restrict anonymous access to Named Pipes and Shares: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters").NullSessionShares
Write-Output "#137 Network access: Shares that can be accessed anonymously: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").ForceGuest
If ($cmd -eq 1)
    {Write-Output "#138 Network access: Sharing and security model for local accounts: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#138 Network access: Sharing and security model for local accounts: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").UseMachineId
If ($cmd -eq 1)
    {Write-Output "#139 Network security: Allow Local System to use computer identity for NTLM: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#139 Network security: Allow Local System to use computer identity for NTLM: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0").allownullsessionfallback
If ($cmd -eq 1)
    {Write-Output "#140 Network security: Allow LocalSystem NULL session fallback: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#140 Network security: Allow LocalSystem NULL session fallback: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\pku2u").AllowOnlineID
If ($cmd -eq 1)
    {Write-Output "#141 Network Security: Allow PKU2U authentication requests to the computer to use online identities:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#141 Network Security: Allow PKU2U authentication requests to the computer to use online identities:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters").SupportedEncryptionTypes
Write-Output "#142 HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").NoLMHash
If ($cmd -eq 1)
    {Write-Output "#143 Network security: Do not store LAN Manager hash value on next password change:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#143 Network security: Do not store LAN Manager hash value on next password change:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").LmCompatibilityLevel
Write-Output "#145 Network security: LAN Manager authentication level: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LDAP").LDAPClientIntegrity
If ($cmd -eq 1)
    {Write-Output "#146 Network security: LDAP client signing requirements:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#146 Network security: LDAP client signing requirements:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0").NTLMMinClientSec
Write-Output "#147 Network security: Minimum session security for NTLM SSP based (including secure RPC) clients: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0").NTLMMinServerSec
Write-Output "#148 Network security: Minimum session security for NTLM SSP based (including secure RPC) servers: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole").SecurityLevel
If ($cmd -eq 1)
    {Write-Output "#149 Recovery console: Allow automatic administrative logon: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#149 Recovery console: Allow automatic administrative logon: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole").SetCommand
If ($cmd -eq 1)
    {Write-Output "#150 Recovery console: Allow floppy copy and access to all drives and all folders: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#150 Recovery console: Allow floppy copy and access to all drives and all folders: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ShutdownWithoutLogon
If ($cmd -eq 1)
    {Write-Output "#151 Shutdown: Allow system to be shut down without having to log on: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#151 Shutdown: Allow system to be shut down without having to log on: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Session Manager\Memory Management").ClearPageFileAtShutdown
If ($cmd -eq 1)
    {Write-Output "#152 Shutdown: Clear virtual memory pagefile: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#152 Shutdown: Clear virtual memory pagefile: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy").Enabled
If ($cmd -eq 1)
    {Write-Output "#153 System cryptography: Use FIPS compliant algorithms for encryption, hashing, and signing: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#153 System cryptography: Use FIPS compliant algorithms for encryption, hashing, and signing: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Session Manager\Kernel").ObCaseInsensitive
If ($cmd -eq 1)
    {Write-Output "#154 System objects: Require case insensitivity for non-Windows subsystems: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#154 System objects: Require case insensitivity for non-Windows subsystems: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Session Manager").ProtectionMode
If ($cmd -eq 1)
    {Write-Output "#155 System objects: Strengthen default permissions of internal system objects (e.g., Symbolic Links): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#155 System objects: Strengthen default permissions of internal system objects (e.g., Symbolic Links): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems").Optional
Write-Output "#156 System settings: Optional subsystems: $cmd"  | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").FilterAdministratorToken
If ($cmd -eq 1)
    {Write-Output "#157 User Account Control: Admin Approval Mode for the Built-in Administrator account: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#157 User Account Control: Admin Approval Mode for the Built-in Administrator account: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableUIADesktopToggle
If ($cmd -eq 1)
    {Write-Output "#158 User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#158 User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ConsentPromptBehaviorAdmin
Write-Output "#159 User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ConsentPromptBehaviorUser
If ($cmd -eq 1)
    {Write-Output "#160 User Account Control: Behavior of the elevation prompt for standard users: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#160 User Account Control: Behavior of the elevation prompt for standard users: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").EnableInstallerDetection
If ($cmd -eq 1)
    {Write-Output "#161 User Account Control: Detect application installations and prompt for elevation: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#161 User Account Control: Detect application installations and prompt for elevation: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ValidateAdminCodeSignatures
If ($cmd -eq 1)
    {Write-Output "#162 User Account Control: Only elevate executables that are signed and validated: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#162 User Account Control: Only elevate executables that are signed and validated: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").EnableSecureUIAPaths
If ($cmd -eq 1)
    {Write-Output "#163 User Account Control: Only elevate UIAccess applications that are installed in secure locations: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#163 User Account Control: Only elevate UIAccess applications that are installed in secure locations: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").EnableLUA
If ($cmd -eq 1)
    {Write-Output "#164 User Account Control: Run all administrators in Admin Approval Mode: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#164 User Account Control: Run all administrators in Admin Approval Mode: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").PromptOnSecureDesktop
If ($cmd -eq 1)
    {Write-Output "#165 User Account Control: Switch to the secure desktop when prompting for elevation: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#165 User Account Control: Switch to the secure desktop when prompting for elevation: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").EnableVirtualization
If ($cmd -eq 1)
    {Write-Output "#166 User Account Control: Virtualize file and registry write failures to per-user locations: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#166 User Account Control: Virtualize file and registry write failures to per-user locations: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile").EnableFirewall
If ($cmd -eq 1)
    {Write-Output "#185 Firewall State (Domain Profile): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#185 Firewall State (Domain Profile): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile").EnableFirewall
If ($cmd -eq 1)
    {Write-Output "#186 Firewall State (Private Profile): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#186 Firewall State (Private Profile): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile").EnableFirewall
If ($cmd -eq 1)
    {Write-Output "#187 Firewall State (Public Profile): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#187 Firewall State (Public Profile): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"


Write-Output "#188 Turn on Mapper I/O (LLTDIO) driver:" | Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").EnableLLTDIO 
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").AllowLLTDIOOnDomain 
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").AllowLLTDIOOnPublicNet
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").ProhibitLLTDIOOnPrivateNet 
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#189 Turn on Responder (RSPNDR) driver:" |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").EnableRspndr
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").AllowRspndrOnDomain 
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").AllowRspndrOnPublicNet
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").ProhibitRspndrOnPrivateNet
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\policies\Microsoft\Peernet").Disabled
If ($cmd -eq 1)
    {Write-Output "#190 Turn Off Microsoft Peer-to-Peer Networking Services: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#190 Turn Off Microsoft Peer-to-Peer Networking Services: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Network Connections").NC_AllowNetBridge_NLA
If ($cmd -eq 1)
    {Write-Output "#191 Prohibit installation and configuration of Network Bridge on your DNS domain network:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#191 Prohibit installation and configuration of Network Bridge on your DNS domain network:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Network Connections").NC_StdDomainUserSetLocation
If ($cmd -eq 1)
    {Write-Output "#192 Require domain users to elevate when setting a network's location:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#192 Require domain users to elevate when setting a network's location:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition").Force_Tunneling
Write-Output "#193 Route all traffic through the internal network: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition").'6to4_State'
Write-Output "#194 6to4 State: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition\IPHTTPS\IPHTTPSInterface").IPHTTPS_ClientState
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition\IPHTTPS\IPHTTPSInterface").IPHTTPS_ClientUrl
Write-Output "#195 IP-HTTPS State: $cmd1, $cmd2"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition").ISATAP_State 
Write-Output "#196 ISATAP State: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition").Teredo_State
Write-Output "#197 Teredo State: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

Write-Output "#198 Configuration of wireless settings using Windows Connect Now:" | Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").EnableRegistrars
If ($cmd -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").DisableUPnPRegistrar
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").DisableInBand802DOT11Registrar
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").DisableFlashConfigRegistrar
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd5 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").DisableWPDRegistrar
If ($cmd5 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd5 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd6 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").MaxWCNDeviceNumber
If ($cmd6 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd6 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd7 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").HigherPrecedenceRegistrar
If ($cmd7 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd7 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\UI").DisableWcnUi
If ($cmd -eq 1)
    {Write-Output "#199 Prohibit Access of the Windows Connect Now wizards:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#199 Prohibit Access of the Windows Connect Now wizards:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Printers").DoNotInstallCompatibleDriverFromWindowsUpdate
If ($cmd -eq 1)
    {Write-Output "#200 Extend Point and Print connection to search Windows Update: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#200 Extend Point and Print connection to search Windows Update: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings").AllowRemoteRPC
If ($cmd -eq 1)
    {Write-Output "#201 Allow remote access to the Plug and Play interface: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#201 Allow remote access to the Plug and Play interface: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings").DisableSendGenericDriverNotFoundToWER
If ($cmd -eq 1)
    {Write-Output "#202 Do not send a Windows Error Report when a generic driver is installed on a device: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#202 Do not send a Windows Error Report when a generic driver is installed on a device: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings").DisableSystemRestore
If ($cmd -eq 1)
    {Write-Output "##203 Prevent creation of a system restore point during device activity that would normally prompt creation of a restore point: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "##203 Prevent creation of a system restore point during device activity that would normally prompt creation of a restore point: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata").PreventDeviceMetadataFromNetwork
If ($cmd -eq 1)
    {Write-Output "#204 Prevent device metadata retrieval from the Internet: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#204 Prevent device metadata retrieval from the Internet: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DriverSearching").SearchOrderConfig 
If ($cmd -eq 1)
    {Write-Output "#205 Specify Search Order for device driver source locations: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#205 Specify Search Order for device driver source locations: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#206 Selectively Allow the evaluation of symbolic links:" |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymLinkState
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymlinkLocalToLocalEvaluation
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymlinkLocalToRemoteEvaluation
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymlinkRemoteToRemoteEvaluation
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd5 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymlinkRemoteToLocalEvaluation
If ($cmd5 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd5 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#207 Registry policy processing:"  |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}").NoBackgroundPolicy
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}").NoGPOListChanges
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate").DisableWindowsUpdateAccess
If ($cmd -eq 1)
    {Write-Output "#208 Turn off access to all Windows Update features: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#208 Turn off access to all Windows Update features: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Printers").DisableWebPnPDownload
If ($cmd -eq 1)
    {Write-Output "#209 Turn off downloading of print drivers over HTTP: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#209 Turn off downloading of print drivers over HTTP: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\EventViewer").MicrosoftEventVwrDisableLinks
If ($cmd -eq 1)
    {Write-Output "#210 Turn off Event Viewer Events.asp links: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#210 Turn off Event Viewer Events.asp links: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TabletPC").PreventHandwritingDataSharing
If ($cmd -eq 1)
    {Write-Output "#211 Turn off handwriting personalization data sharing: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#211 Turn off handwriting personalization data sharing: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TabletPC").PreventHandwritingDataSharing
If ($cmd -eq 1)
    {Write-Output "#212 Turn off handwriting recognition error reporting: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#212 Turn off handwriting recognition error reporting: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc").Headlines
If ($cmd -eq 1)
    {Write-Output "#213 Turn off Help and Support Center (Did you know?) content: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#213 Turn off Help and Support Center (Did you know?) content: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc").MicrosoftKBSearch
If ($cmd -eq 1)
    {Write-Output "#214 Turn off Help and Support Center Microsoft Knowledge Base search: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#214 Turn off Help and Support Center Microsoft Knowledge Base search: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Internet Connection Wizard").ExitOnMSICW
If ($cmd -eq 1)
    {Write-Output "#215 Turn off Internet Connection Wizard if URL connection is referring to Microsoft.com: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#215 Turn off Internet Connection Wizard if URL connection is referring to Microsoft.com: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoWebServices
If ($cmd -eq 1)
    {Write-Output "#216 Turn off Internet download for Web publishing and online ordering wizards: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#216 Turn off Internet download for Web publishing and online ordering wizards: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoInternetOpenWith
If ($cmd -eq 1)
    {Write-Output "#217 Turn off Internet File Association service: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#217 Turn off Internet File Association service: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Printers").DisableHTTPPrinting
If ($cmd -eq 1)
    {Write-Output "#218 Turn off printing over HTTP: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#218 Turn off printing over HTTP: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Registration Wizard Control").NoRegistration
If ($cmd -eq 1)
    {Write-Output "#219 Turn off Registration if URL connection is referring to Microsoft.com: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#219 Turn off Registration if URL connection is referring to Microsoft.com: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\SearchCompanion").DisableContentFileUpdates
If ($cmd -eq 1)
    {Write-Output "#220 Turn off Search Companion content file updates: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#220 Turn off Search Companion content file updates: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoOnlinePrintsWizard
If ($cmd -eq 1)
    {Write-Output "#221 Turn off the Order Prints picture task: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#221 Turn off the Order Prints picture task: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoPublishingWizard
If ($cmd -eq 1)
    {Write-Output "#222 Turn off the Publish to Web task for files and folders: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#222 Turn off the Publish to Web task for files and folders: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Messenger\Client").CEIP
Write-Output "#223 Turn off the Windows Messenger Customer Experience Improvement Program: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\SQMClient\Windows").CEIPEnable
If ($cmd -eq 1)
    {Write-Output "#224 Turn off Windows Customer Experience Improvement Program: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#224 Turn off Windows Customer Experience Improvement Program: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#225 Turn off Windows Error Reporting:"   |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting").DoReport
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting").Disabled 
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DriverSearching").DontSearchWindowsUpdate
If ($cmd -eq 1)
    {Write-Output "#226 Turn off Windows Update device driver searching: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#226 Turn off Windows Update device driver searching: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").LogonType
If ($cmd -eq 1)
    {Write-Output "#227 Always use classic logon: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#227 Always use classic logon: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").DisableLocalMachineRunOnce
If ($cmd -eq 1)
    {Write-Output "#228 Do not process the run once list: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#228 Do not process the run once list: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51").DCSettingIndex
If ($cmd -eq 1)
    {Write-Output "#229 Require a Password When a Computer Wakes (On Battery): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#229 Require a Password When a Computer Wakes (On Battery): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51").ACSettingIndex
If ($cmd -eq 1)
    {Write-Output "##230 Require a Password When a Computer Wakes (Plugged In): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "##230 Require a Password When a Computer Wakes (Plugged In): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKEY_LOCAL_MACHINE:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364\DCSettingIndex").3600 
Write-Output "#231 Specify the System Hibernate Timeout (On Battery): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKEY_LOCAL_MACHINE:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364\ACSettingIndex").3600
Write-Output "#232 Specify the System Hibernate Timeout (Plugged In): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKEY_LOCAL_MACHINE:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364\DCSettingIndex").1200
Write-Output "#233 Turn off the Display (On Battery): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKEY_LOCAL_MACHINE:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364\ACSettingIndex").1200
Write-Output "#234 Turn off the Display (On Battery): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

Write-Output "#235 Offer Remote Assistance:"  |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fAllowUnsolicited
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fAllowUnsolicitedFullControl
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd3 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fAllowUnsolicitedFullControl
Write-Output `n | Out-File -Append "$file"

Write-Output "#236 Solicited Remote Assistance:"  |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fAllowToGetHelp
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fAllowFullControl
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd3 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").MaxTicketExpiry 
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd4 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").MaxTicketExpiryUnits 
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd5 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fUseMailto 
If ($cmd5 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd5 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").LoggingEnabled
If ($cmd -eq 1)
    {Write-Output "#237 Turn on session logging: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#237 Turn on session logging: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Rpc").RestrictRemoteClients
If ($cmd -eq 1)
    {Write-Output "#238 Restrictions for Unauthenticated RPC clients: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#238 Restrictions for Unauthenticated RPC clients: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Rpc").EnableAuthEpResolution
If ($cmd -eq 1)
    {Write-Output "#239 RPC Endpoint Mapper Client Authentication: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#239 RPC Endpoint Mapper Client Authentication: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy").DisableQueryRemoteServer
If ($cmd -eq 1)
    {Write-Output "#240 Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#240 Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy").EnableQueryRemoteServer
If ($cmd -eq 1)
    {Write-Output "#241 Troubleshooting: Allow users to access online troubleshooting content on Microsoft servers from the Troubleshooting Control Panel (via the Windows Online Troubleshooting Service - WOTS):  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#241 Troubleshooting: Allow users to access online troubleshooting content on Microsoft servers from the Troubleshooting Control Panel (via the Windows Online Troubleshooting Service - WOTS):  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}").ScenarioExecutionEnabled
If ($cmd -eq 1)
    {Write-Output "#242 Enable/Disable PerfTrack: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#242 Enable/Disable PerfTrack: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\W32time\Parameters").NtpServer
If ($cmd -eq 1)
    {Write-Output "#243 Configure Windows NTP Client\NtpServer: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#243 Configure Windows NTP Client\NtpServer: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\AppCompat").DisableInventory
If ($cmd -eq 1)
    {Write-Output "#244 Turn off Program Inventory: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#244 Turn off Program Inventory: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoAutorun
If ($cmd -eq 1)
    {Write-Output "#245 Default behavior for AutoRun: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#245 Default behavior for AutoRun: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoDriveTypeAutoRun
Write-Output "#246 Turn off Autoplay: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoAutoplayfornonVolume
If ($cmd -eq 1)
    {Write-Output "#247 Turn off Autoplay for non-volume devices: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#247 Turn off Autoplay for non-volume devices: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI").EnumerateAdministrators
If ($cmd -eq 1)
    {Write-Output "#248 Enumerate administrator accounts on elevation: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#248 Enumerate administrator accounts on elevation: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar").OverrideMoreGadgetsLink
Write-Output "#249 Override the More Gadgets link: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar").TurnOffUnsignedGadgets
If ($cmd -eq 1)
    {Write-Output "#250 Restrict unpacking and installation of gadgets that are not digitally signed: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#250 Restrict unpacking and installation of gadgets that are not digitally signed: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar").TurnOffUserInstalledGadgets
If ($cmd -eq 1)
    {Write-Output "#251 Turn Off user-installed desktop gadgets: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#251 Turn Off user-installed desktop gadgets: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Digital Locker").DoNotRunDigitalLocker
If ($cmd -eq 1)
    {Write-Output "#252 Do not allow Digital Locker to run: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#252 Do not allow Digital Locker to run: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application").AutoBackupLogFiles
If ($cmd -eq 1)
    {Write-Output "#253 Backup log files automatically when full: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#253 Backup log files automatically when full: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application").MaxSize
Write-Output "#254 Maximum Log Size (KB): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application").Retention
If ($cmd -eq 1)
    {Write-Output "#255 Retain old events: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#255 Retain old events: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security").AutoBackupLogFiles
If ($cmd -eq 1)
    {Write-Output "#256 Backup log files automatically when full: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#256 Backup log files automatically when full: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security").MaxSize
Write-Output "#257 Maximum Log Size (KB): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security").Retention
If ($cmd -eq 1)
    {Write-Output "#258 Retain old events: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#258 Retain old events: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup").MaxSize
Write-Output "#259 Maximum Log Size (KB): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\System").AutoBackupLogFiles
If ($cmd -eq 1)
    {Write-Output "#260 Backup log files automatically when full: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#260 Backup log files automatically when full: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\System").MaxSize
Write-Output "#261 Maximum Log Size (KB): $cmd "  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\System").Retention 
If ($cmd -eq 1)
    {Write-Output "#262 Retain old events: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#262 Retain old events: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\GameUX").DownloadGameInfo
If ($cmd -eq 1)
    {Write-Output "#263 Turn off downloading of game information: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#263 Turn off downloading of game information:: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\GameUX").GameUpdateOptions
If ($cmd -eq 1)
    {Write-Output "#264 Turn off game updates: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#264 Turn off game updates: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\HomeGroup").DisableHomeGroup
If ($cmd -eq 1)
    {Write-Output "#265 Prevent the computer from joining a homegroup: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#265 Prevent the computer from joining a homegroup: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Conferencing").NoRDS
If ($cmd -eq 1)
    {Write-Output "#266 Disable remote Desktop Sharing: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#266 Disable remote Desktop Sharing: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fDenyTSConnections
If ($cmd -eq 1)
    {Write-Output "#267 Allow users to connect remotely using Remote Desktop Services: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#267 Allow users to connect remotely using Remote Desktop Services: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fDisableCcm 
If ($cmd -eq 1)
    {Write-Output "#268 Do not allow COM port redirection: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#268 Do not allow COM port redirection: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fDisableCdm
If ($cmd -eq 1)
    {Write-Output "#269 Do not allow drive redirection: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#269 Do not allow drive redirection: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fDisablePNPRedir
If ($cmd -eq 1)
    {Write-Output "#270 Do not allow supported Plug and Play device redirection: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#270 Do not allow supported Plug and Play device redirection: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fNoRemoteDesktopWallpaper
If ($cmd -eq 1)
    {Write-Output "#271 Enforce Removal of Remote Desktop Wallpaper: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#271 Enforce Removal of Remote Desktop Wallpaper: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fPromptForPassword 
If ($cmd -eq 1)
    {Write-Output "#271 Enforce Removal of Remote Desktop Wallpaper: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#271 Enforce Removal of Remote Desktop Wallpaper: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fEncryptRPCTraffic
If ($cmd -eq 1)
    {Write-Output "#273 Require secure RPC communication: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#273 Require secure RPC communication: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").SecurityLayer
If ($cmd -eq 1)
    {Write-Output "#274 Require use of specific security layer for remote (RDP) connections: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#274 Require use of specific security layer for remote (RDP) connections: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").MinEncryptionLevel
If ($cmd -eq 1)
    {Write-Output "#275 Set client connection encryption level: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#275 Set client connection encryption level: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").MaxIdleTime
If ($cmd -eq 1)
    {Write-Output "#276 Set time limit for active but idle Remote Desktop Services sessions: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#276 Set time limit for active but idle Remote Desktop Services sessions: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").MaxDisconnectionTime
If ($cmd -eq 1)
    {Write-Output "#277 Set time limit for disconnected sessions: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#277 Set time limit for disconnected sessions: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fResetBroken
If ($cmd -eq 1)
    {Write-Output "#278 Terminate session when time limits are reached: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#278 Terminate session when time limits are reached: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").DeleteTempDirsOnExit
If ($cmd -eq 1)
    {Write-Output "#279 Do not delete temp folder upon exit: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#279 Do not delete temp folder upon exit: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").PerSessionTempDir
If ($cmd -eq 1)
    {Write-Output "#280 Do not use temporary folders per session: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#280 Do not use temporary folders per session: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").DisablePasswordSaving
If ($cmd -eq 1)
    {Write-Output "#281 Do not allow passwords to be saved: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#281 Do not allow passwords to be saved: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds").DisableEnclosureDownload
If ($cmd -eq 1)
    {Write-Output "#282 Turn off downloading of enclosures: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#282 Turn off downloading of enclosures: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search").AllowIndexingEncryptedStoresOrItems
If ($cmd -eq 1)
    {Write-Output "283 Allow indexing of encrypted files: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "283 Allow indexing of encrypted files: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search").PreventIndexingUncachedExchangeFolders
If ($cmd -eq 1)
    {Write-Output "284 Enable indexing uncached Exchange folders: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "284 Enable indexing uncached Exchange folders: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\WAU").Disabled
If ($cmd -eq 1)
    {Write-Output "285 Prevent Windows Anytime Upgrade from running: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "285 Prevent Windows Anytime Upgrade from running: DISABLED" | Out-File -Append "$file"}
Write-Output "#285 Prevent Windows Anytime Upgrade from running: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows Defender").SpyNetReporting
If ($cmd -eq 1)
    {Write-Output "286 Configure Microsoft Spynet Reporting: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "286 Configure Microsoft Spynet Reporting: DISABLED" | Out-File -Append "$file"}
rite-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows Defender").DisableAntiSpyware
If ($cmd -eq 1)
    {Write-Output "287 Turn off Windows Defender: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "287 Turn off Windows Defender: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting").LoggingDisabled
If ($cmd -eq 1)
    {Write-Output "288 Disable Logging: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "288 Disable Logging: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting").Disabled
If ($cmd -eq 1)
    {Write-Output "289 Disable Windows Error Reporting: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "289 Disable Windows Error Reporting: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting").ShowUI
If ($cmd -eq 1)
    {Write-Output "289 Disable Windows Error Reporting: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "289 Disable Windows Error Reporting: DISABLED" | Out-File -Append "$file"}

Write-Output "#290 Display Error Notification:"  |  Out-File -Append "$file"
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW").DWAllowHeadless
If ($cmd -eq 1)
    {Write-Output "289 Disable Windows Error Reporting: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "289 Disable Windows Error Reporting: DISABLED" | Out-File -Append "$file"}
Write-Output "#290 Display Error Notification: $cmd1 , $cmd2 "  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting").DontSendAdditionalData
Write-Output "#291 Do not send additional data: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Explorer").NoDataExecutionPrevention
Write-Output "#292 Turn off Data Execution Prevention for Explorer: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Explorer").NoHeapTerminationOnCorruption
Write-Output "#293 Turn off heap termination on corruption: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").PreXPSP2ShellProtocolBehavior
Write-Output "#294 Turn off shell protocol protected mode: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Installer").SafeForScripting
Write-Output "#295 Disable IE security prompt for Windows Installer scripts: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Installer").EnableUserControl
Write-Output "#296 Enable user control over installs: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Installer").DisableLUAPatching 
Write-Output "#297 Prohibit non-administrators from applying vendor signed updates: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ReportControllerMissing 
Write-Output "#298 Report when logon server was not available during user logon: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows Mail").DisableCommunities
Write-Output "#299 Turn off the communities features: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows Mail").ManualLaunchAllowed
Write-Output "#300 Turn off Windows Mail application: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WMDRM").DisableOnline
Write-Output "#301 Prevent Windows Media DRM Internet Access: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer").GroupPrivacyAcceptance
Write-Output "#302 Do Not Show First Use Dialog Boxes: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer").DisableAutoUpdate
Write-Output "#303 Prevent Automatic Updates: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").NoAutoUpdate 
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").AUOptions
$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").ScheduledInstallDay
$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").ScheduledInstallTime
Write-Output "#304 Configure Automatic Updates: $cmd1 , $cmd2 , $cmd3 , $cmd4 " |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd =(gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").NoAUShutdownOption
Write-Output "#305 Do not display 'Install Updates and Shut Down' option in Shut Down Windows dialog box: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd =(gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").NoAutoRebootWithLoggedOnUsers
Write-Output "#306 No auto-restart with logged on users for scheduled automatic updates installations; $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").RescheduleWaitTimeEnabled
$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").RescheduleWaitTime
Write-Output "#307 Reschedule Automatic Updates scheduled installations: $cmd, $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").UseWUServer
Write-Output "#308 Specify intranet Microsoft update service location: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop").ScreenSaveActive
Write-Output "#309 Enable screen saver: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop").ScreenSaverIsSecure
Write-Output "#310 Password protect the screen saver: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop").ScreenSaveTimeOut
Write-Output "#311 Screen Saver timeout: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Policies\Microsoft\Assistance\Client\1.0").NoExplicitFeedback
Write-Output "#312 Turn off Help Ratings: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments").SaveZoneInformation 
Write-Output "#313 Do not preserve zone information in file attachments: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments").HideZoneInfoOnProperties
Write-Output "#314 Hide mechanisms to remove zone information: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments").ScanWithAntiVirus
Write-Output "#315 Notify antivirus programs when opening attachments: $cmd "  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoInplaceSharing
Write-Output "#316 Prevent users from sharing files within their profile.: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\bthserv").start
Write-Output "#323 Bluetooth Support Service: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\Fax").start
Write-Output "#324 Fax: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\HomeGroupListener").start
Write-Output "#325 HomeGroup Listener: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\HomeGroupProvider").start
Write-Output "#326 HomeGroup Provider: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\Mcx2Svc").start
Write-Output "#327 Media Center Extender Service: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\WPCSvc").start
Write-Output "#328 Parental Controls: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\BFE").start
Write-Output "#329 Base Filtering Engine: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\EventSystem").Start
Write-Output "#330 COM+ Event System: "  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\CryptSvc").start
Write-Output "#331 Cryptographic Services: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\UxSms").start
Write-Output "#332 Desktop Window Manager Session Manager: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Dhcp").start
Write-Output "#333 DHCP Client: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\gpsvc").start
Write-Output "#334 Group Policy Client: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\IKEEXT").start
Write-Output "#335 IKE and AuthIP IPsec Keying Modules: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\iphlpsvc").start
Write-Output "#336 IP Helper: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\iphlpsvc").start
Write-Output "#337 Network Location Awareness: $cmd"|  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\nsi").start
Write-Output "#338 Network Store Interface Service: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\PlugPlay").Start
Write-Output "#339 Plug and Play"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Power").start
Write-Output "#340 Power: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\RpcSs").start
Write-Output "#341 Remote Procedure Call (RPC): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\RpcEptMapper").start
Write-Output "#342 RPC Endpoint Mapper: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\SamSs").start
Write-Output "#343 Security Accounts Manager: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\ShellHWDetection").start
Write-Output "344 Shell Hardware Detection: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\sppsvc").start
Write-Output "#345 Software Protection: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Schedule").start
Write-Output "#346 Task Scheduler: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\lmhosts").start
Write-Output "#347 TCP/IP NetBIOS Helper: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\ProfSvc").start
Write-Output "#348 User Profile Service: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\eventlog").start
Write-Output "#349 Windows Event Log: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Winmgmt").start
Write-Output "#350 Windows Management Instrumentation: $cmd"  |  Out-$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = hostname
$share = "C:\temp\ISSO\$server"
$file = "$share\$server`_$timestamp.txt"
$log = "$share\$server`_log.txt"
$ErrorActionPreference="SilentlyContinue"
$name= (Get-Item Env:\COMPUTERNAME).value
$computerSystem = Get-CimInstance CIM_ComputerSystem
$computerBIOS = Get-CimInstance CIM_BIOSElement
$computerOS = Get-CimInstance CIM_OperatingSystem
$computerCPU = Get-CimInstance CIM_Processor
$computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"
Clear-Host


Write-Host "`nScanning $server ... "
if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }

$user = whoami

Write-Output "Script executed by $user"`n | Out-File "$file"


Write-Output "PLEASE NOTE THE VALUES OF THE OUTPUT : 1 = ENABLED ; 0 = DISABLED ; TRUE = INSTALLED ; FALSE = NOT INSTALLED" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

Write-Output "#4 Only hardware listed on the IRM approved Hardware List shall be used with a computer running Windows 7"| Out-File -Append "$file"

"Manufacturer: " + $computerSystem.Manufacturer | Out-File -Append "$file"
"Model: " + $computerSystem.Model | Out-File -Append "$file"
"Serial Number: " + $computerBIOS.SerialNumber | Out-File -Append "$file"
"CPU: " + $computerCPU.Name | Out-File -Append "$file"
"HDD Capacity: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB" | Out-File -Append "$file"
"HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)" | Out-File -Append "$file"
"RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB" | Out-File -Append "$file"
"Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (Get-UiCulture).DisplayName
Write-Output "#11 The workstation shall have a regional language set to U.S: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

Write-Output "#12 All Windows 7 workstations shall follow the approved standard naming convention: $name" |  Out-File -Append "$file"
$cmd1 = (gp 'HKLM:\SOFTWARE\Symantec\Symantec Endpoint Protection\CurrentVersion').'ProductName'
$cmd2 = (gp 'HKLM:\SOFTWARE\Symantec\Symantec Endpoint Protection\SMC').'ProductVersion'
Write-Output `n | Out-File -Append "$file"

Write-Output "#14 Virus-scanning software with the latest virus definitions shall be installed: $cmd1 $cmd2" | Out-File -Append "$file"

Write-Output "#15 Only ITCCB approved versions of the Microsoft .NET framework shall be installed:" |  Out-File -Append "$file"
ls $Env:windir\Microsoft.NET\Framework | ? { $_.PSIsContainer -and $_.Name -match '^v\d.[\d\.]+' } | % { $_.Name.TrimStart('v') } | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableLUA
If ($cmd -eq 1) 
    {Write-Output "#16 User Account Control Enabled and set to Always Notify: ENABLED" | Out-File -Append "$file"}   
elseif ($cmd -eq 0) 
    {Write-Output "#16 User Account Control Enabled and set to Always Notify: DISABLED " | Out-File -Append "$file"}    
Write-Output `n | Out-File -Append "$file"

#$cmd = test-path "C:\Program Files\Microsoft Games"
#If ($cmd -eq "False") 
#   {Write-Output "#17 Games: Installed" | Out-File -Append "$file"}   
#elseif ($cmd -eq "True") 
#    {Write-Output "#17 Games: Not Installed" | Out-File -Append "$file"} 

Write-Output `n | Out-File -Append "$file"

$cmd = test-path "HKLM\SYSTEM\CurrentControlSet\Services\W3Svc\DisplayName"
Write-Output "#18 Internet Information Services Not Installed: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "HKLM\SYSTEM\CurrentControlSet\Services\simptcp\DisplayName"
Write-Output "#19 SimpleTCP Services Not Installed: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "C:\Windows\system32\telnet.exe"
Write-Output "#20 Telnet Client Not Installed: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "HKLM\SYSTEM\CurrentControlSet\Services"
Write-Output "#21 Telnet Server Not Installed: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "C:\Windows\system32\tftp.exe"
Write-Output "#22 TFTP Client Not Installed: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = test-path "C:\Windows\ehome\ehshell.exe"
Write-Output "#23 Windows Media Center Not Installed: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").LimitBlankPasswordUse
If ($cmd -eq 1)
    {Write-Output "#79 Accounts: Limit local account use of blank passwords to console logon only: ENABLED"  | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#79 Accounts: Limit local account use of blank passwords to console logon only: DISABLED"  | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").AuditBaseObjects
If ($cmd -eq 1)
    {Write-Output "#82 Audit: Audit the access of global system objects: ENABLED"  |  Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#82 Audit: Audit the access of global system objects: DISABLED"  |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

#$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").FullPrivilegeAuditing
#If ($cmd -eq 1)
#    {Write-Output "#83 Audit: Audit the use of Backup and Restore privilege: ENABLED" | Out-File -Append "$file"}
#elseif ($cmd -eq 0)
#    {Write-Output "#83 Audit: Audit the use of Backup and Restore privilege: DISABLED" | Out-File -Append "$file"}
#Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").SCENoApplyLegacyAuditPolicy
If ($cmd -eq 1) 
    {Write-Output "#84 Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#84 Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings: DIABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").SCENoApplyLegacyAuditPolicy
If ($cmd -eq 1)
    {Write-Output "#85 Audit: Shut down system immediately if unable to log security audits: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#85 Audit: Shut down system immediately if unable to log security audits: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").'undockwithoutlogon'
If ($cmd -eq 1)
    {Write-Output "#86 Devices: Allow undock without having to log on: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#86 Devices: Allow undock without having to log on: DISABLED"| Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").AllocateDASD
If ($cmd -eq 1)
    {Write-Output "#87 Devices: Allowed to format and eject removable media: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#87 Devices: Allowed to format and eject removable media: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers").AddPrinterDrivers
If ($cmd -eq 1)
    {Write-Output "#88 Devices: Prevent users from installing printer drivers: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#88 Devices: Prevent users from installing printer drivers: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").AllocateCDRoms
If ($cmd -eq 1)
    {Write-Output "#89 Devices: Restrict CD-ROM access to locally logged-on user only: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#89 Devices: Restrict CD-ROM access to locally logged-on user only: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").AllocateFloppies 
If ($cmd -eq 1)
    {Write-Output "#90 Devices: Restrict floppy access to locally logged-on user only: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#90 Devices: Restrict floppy access to locally logged-on user only: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").RequireSignOrSeal
If ($cmd -eq 1)
    {Write-Output "#91 Domain member: Digitally encrypt or sign secure channel data (always): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#91 Domain member: Digitally encrypt or sign secure channel data (always): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").SealSecureChannel 
If ($cmd -eq 1)
    {Write-Output "#92 Domain member: Digitally encrypt secure channel data (when possible): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#92 Domain member: Digitally encrypt secure channel data (when possible): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").SignSecureChannel
If ($cmd -eq 1)
    {Write-Output "#93 Domain member: Digitally sign secure channel data (when possible): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#93 Domain member: Digitally sign secure channel data (when possible): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").DisablePasswordChange
If ($cmd -eq 1)
    {Write-Output "#94 Domain member: Disable machine account password changes: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#94 Domain member: Disable machine account password changes: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").MaximumPasswordAge
Write-Output "#95 Domain member: Maximum machine account password age: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters").RequireStrongKey
If ($cmd -eq 1)
    {Write-Output "#96 Domain member: Require strong (Windows 2000 or later) session key: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#96 Domain member: Require strong (Windows 2000 or later) session key: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").DontDisplayLockedUserID
If ($cmd -eq 1)
    {Write-Output "#97 Interactive logon: Display user information when session is locked: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#97 Interactive logon: Display user information when session is locked: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").DontDisplayLastUserName
If ($cmd -eq 1)
    {Write-Output "#98 Interactive logon: Do not display last user name: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#98 Interactive logon: Do not display last user name: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").DisableCAD
If ($cmd -eq 1)
    {Write-Output "#99 Interactive logon: Do not require CTRL+ALT+DELETE: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#99 Interactive logon: Do not require CTRL+ALT+DELETE: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").LegalNoticeText
Write-Output "#100 Interactive logon: Message text for users attempting to logon: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").LegalNoticeCaption
Write-Output "#101 Interactive logon: Message title for users attempting to logon: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").CachedLogonsCount
Write-Output "#102 Interactive logon: Number of previous logons to cache (in case domain controller is not available): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").PasswordExpiryWarning
Write-Output "#103 Interactive logon: Prompt user to change password before expiration: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").ForceUnlockLogon
If ($cmd -eq 1)
    {Write-Output "#104 Interactive logon: Prompt user to change password before expiration: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#104 Interactive logon: Prompt user to change password before expiration: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").ScRemoveOption
If ($cmd -eq 1)
    {Write-Output "#105 Interactive logon: Smart card removal behavior: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#105 Interactive logon: Smart card removal behavior: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters").RequireSecuritySignature
If ($cmd -eq 1)
    {Write-Output "#106 Microsoft network client: Digitally sign communications (always): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#106 Microsoft network client: Digitally sign communications (always): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters").EnableSecuritySignature
If ($cmd -eq 1)
    {Write-Output "#107 Microsoft network client: Digitally sign communications (if server agrees): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#107 Microsoft network client: Digitally sign communications (if server agrees): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters").EnablePlainTextPassword
If ($cmd -eq 1)
    {Write-Output "#108 Microsoft network client: Send unencrypted password to third-party SMB servers: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#108 Microsoft network client: Send unencrypted password to third-party SMB servers: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").AutoDisconnect 
Write-Output "#109 Microsoft network server: Amount of idle time required before suspending session: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").RequireSecuritySignature
If ($cmd -eq 1)
    {Write-Output "#110 Microsoft network server: Digitally sign communications (always): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#110 Microsoft network server: Digitally sign communications (always): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").EnableSecuritySignature
If ($cmd -eq 1)
    {Write-Output "#111 Microsoft network server: Digitally sign communications (if client agrees):  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#111 Microsoft network server: Digitally sign communications (if client agrees):  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").EnableForcedLogOff 
If ($cmd -eq 1)
    {Write-Output "#112 Microsoft network server: Disconnect clients when logon hours expire:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#112 Microsoft network server: Disconnect clients when logon hours expire:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters").SMBServerNameHardeningLevel 
If ($cmd -eq 1)
    {Write-Output "#113 Microsoft network server: Server SPN target name validation level: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#113 Microsoft network server: Server SPN target name validation level: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").AutoAdminLogon
If ($cmd -eq 1)
    {Write-Output "#114 Enable Automatic Logon (Not Recommended): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#114 Enable Automatic Logon (Not Recommended): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters").DisableIPSourceRouting 
If ($cmd -eq 0)
    {Write-Output "#115 MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing): ENABLES SOURCE ROUTING" | Out-File -Append "$file"}
elseif ($cmd -eq 1)
    {Write-Output "#115 MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing): DISABLES SOURCE ROUTING WHEN IP FORWARDING IS ALSO ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 2)
    {Write-Output "#115 MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing): DISABLES SOURCE ROUTING COMPLETELY" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").DisableIPSourceRouting 
If ($cmd -eq 0)
    {Write-Output "#116 MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing): ENABLES SOURCE ROUTING" | Out-File -Append "$file"}
elseif ($cmd -eq 1)
    {Write-Output "#116 MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing): DISABLES SOURCE ROUTING WHEN IP FORWARDING IS ALSO ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 2)
    {Write-Output "#116 MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing): DISABLES SOURCE ROUTING COMPLETELY" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").EnableICMPRedirect
If ($cmd -eq 1)
    {Write-Output "#117 MSS: (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#117 MSS: (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Lanmanserver\Parameters").Hidden
If ($cmd -eq 1)
    {Write-Output "#118 MSS: (Hidden) Hide computer from the browse list (Not Recommended except for highly secure environments:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#118 MSS: (Hidden) Hide computer from the browse list (Not Recommended except for highly secure environments: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").KeepAliveTime
Write-Output "#119 MSS: (KeepAliveTime) How often keep-alive packets are sent in milliseconds: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\IPSEC").NoDefaultExempt
If ($cmd -eq 1)
    {Write-Output "#120 MSS: (NoDefaultExempt) Configure IPSec exemptions for various types of network traffic:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#120 MSS: (NoDefaultExempt) Configure IPSec exemptions for various types of network traffic: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Netbt\Parameters").NoNameReleaseOnDemand
If ($cmd -eq 1)
    {Write-Output "#121 MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#121 MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").PerformRouterDiscovery
If ($cmd -eq 1)
    {Write-Output "#122 MSS: (PerformRouterDiscovery) Allow IRDP to detect and configure DefaultGateway addresses (could lead to DoS): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#122 MSS: (PerformRouterDiscovery) Allow IRDP to detect and configure DefaultGateway addresses (could lead to DoS): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager").SafeDllSearchMode 
If ($cmd -eq 1)
    {Write-Output "#123 MSS: (SafeDLLSearchMode) Enable safe DLL search mode (Recommended): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#123 MSS: (SafeDLLSearchMode) Enable safe DLL search mode (Recommended): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").ScreenSaverGracePeriod
Write-Output "#124 MSS: (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires (0 Recommended): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters").TcpMaxDataRetransmissions
Write-Output "#125 MSS: (TcpMaxDataRetransmissions IPv6) How many times unacknowledged data is retransmitted (3 recommended, 5 is default): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters").TcpMaxDataRetransmissions 
Write-Output "#126 MSS: (TCPMaxDataRetransmissions) How many times unacknowledged data is retransmitted (3 Recommended, 5 is Default): $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Eventlog\Security").WarningLevel
Write-Output "#127 MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").RestrictAnonymousSAM
If ($cmd -eq 1)
    {Write-Output "#129 Network access: Do not allow anonymous enumeration of SAM accounts: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#129 Network access: Do not allow anonymous enumeration of SAM accounts: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").RestrictAnonymous
If ($cmd -eq 1)
    {Write-Output "#130 Network access: Do not allow anonymous enumeration of SAM accounts and shares: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#130 Network access: Do not allow anonymous enumeration of SAM accounts and shares: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").DisableDomainCreds
If ($cmd -eq 1)
    {Write-Output "#131 Network access: Do not allow storage of passwords and credentials for network authentication: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#131 Network access: Do not allow storage of passwords and credentials for network authentication: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").everyoneincludesanonymous
If ($cmd -eq 1)
    {Write-Output "#132 Network access: Let Everyone permissions apply to anonymous users: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#132 Network access: Let Everyone permissions apply to anonymous users: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters").NullSessionPipes
Write-Output "#133 Network access: Named Pipes that can be accessed anonymously: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths").Machine
Write-Output "#134 Network access: Remotely accessible registry paths: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedPaths").Machine
Write-Output "#135 Network access: Remotely accessible registry paths and subpaths: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters").restrictnullsessaccess 
If ($cmd -eq 1)
    {Write-Output "#136 Network access: Restrict anonymous access to Named Pipes and Shares: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#136 Network access: Restrict anonymous access to Named Pipes and Shares: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters").NullSessionShares
Write-Output "#137 Network access: Shares that can be accessed anonymously: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").ForceGuest
If ($cmd -eq 1)
    {Write-Output "#138 Network access: Sharing and security model for local accounts: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#138 Network access: Sharing and security model for local accounts: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").UseMachineId
If ($cmd -eq 1)
    {Write-Output "#139 Network security: Allow Local System to use computer identity for NTLM: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#139 Network security: Allow Local System to use computer identity for NTLM: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0").allownullsessionfallback
If ($cmd -eq 1)
    {Write-Output "#140 Network security: Allow LocalSystem NULL session fallback: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#140 Network security: Allow LocalSystem NULL session fallback: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\pku2u").AllowOnlineID
If ($cmd -eq 1)
    {Write-Output "#141 Network Security: Allow PKU2U authentication requests to the computer to use online identities:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#141 Network Security: Allow PKU2U authentication requests to the computer to use online identities:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters").SupportedEncryptionTypes
Write-Output "#142 HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").NoLMHash
If ($cmd -eq 1)
    {Write-Output "#143 Network security: Do not store LAN Manager hash value on next password change:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#143 Network security: Do not store LAN Manager hash value on next password change:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa").LmCompatibilityLevel
If ($cmd -eq 0)
    {Write-Output "#145 Network security: LAN Manager authentication level:  SEND LM RESPONSE AND NTLM RESPONSE; NEVER USE NTLMv2 SESSION SECURITY" | Out-File -Append "$file"}
elseif ($cmd -eq 1)
    {Write-Output "#145 Network security: LAN Manager authentication level:  USE NTLMv2 SESSION SECURITY IF NEGOTIATED" | Out-File -Append "$file"}
elseif ($cmd -eq 2)
    {Write-Output "#145 Network security: LAN Manager authentication level:  SEND NTLM AUTHENTICATION ONLY" | Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#145 Network security: LAN Manager authentication level:  SEND HTLMv2 AUTHENTICATION ONLY" | Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#145 Network security: LAN Manager authentication level:  DC REFUSES LM AUTHENTICATION" | Out-File -Append "$file"}
elseif ($cmd -eq 5)
    {Write-Output "#145 Network security: LAN Manager authentication level:  DC REFUSES LM AND NTLM AUTHENTICATION (ACCEPTS ONLY HTLMv2)" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Services\LDAP").LDAPClientIntegrity
If ($cmd -eq 1)
    {Write-Output "#146 Network security: LDAP client signing requirements:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#146 Network security: LDAP client signing requirements:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0").NTLMMinClientSec
Write-Output "#147 Network security: Minimum session security for NTLM SSP based (including secure RPC) clients: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0").NTLMMinServerSec
Write-Output "#148 Network security: Minimum session security for NTLM SSP based (including secure RPC) servers: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole").SecurityLevel
If ($cmd -eq 1)
    {Write-Output "#149 Recovery console: Allow automatic administrative logon: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#149 Recovery console: Allow automatic administrative logon: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole").SetCommand
If ($cmd -eq 1)
    {Write-Output "#150 Recovery console: Allow floppy copy and access to all drives and all folders: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#150 Recovery console: Allow floppy copy and access to all drives and all folders: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ShutdownWithoutLogon
If ($cmd -eq 1)
    {Write-Output "#151 Shutdown: Allow system to be shut down without having to log on: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#151 Shutdown: Allow system to be shut down without having to log on: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Session Manager\Memory Management").ClearPageFileAtShutdown
If ($cmd -eq 1)
    {Write-Output "#152 Shutdown: Clear virtual memory pagefile: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#152 Shutdown: Clear virtual memory pagefile: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy").Enabled
If ($cmd -eq 1)
    {Write-Output "#153 System cryptography: Use FIPS compliant algorithms for encryption, hashing, and signing: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#153 System cryptography: Use FIPS compliant algorithms for encryption, hashing, and signing: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Session Manager\Kernel").ObCaseInsensitive
If ($cmd -eq 1)
    {Write-Output "#154 System objects: Require case insensitivity for non-Windows subsystems: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#154 System objects: Require case insensitivity for non-Windows subsystems: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\System\CurrentControlSet\Control\Session Manager").ProtectionMode
If ($cmd -eq 1)
    {Write-Output "#155 System objects: Strengthen default permissions of internal system objects (e.g., Symbolic Links): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#155 System objects: Strengthen default permissions of internal system objects (e.g., Symbolic Links): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Subsystems").Optional
Write-Output "#156 System settings: Optional subsystems: $cmd"  | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").FilterAdministratorToken
If ($cmd -eq 1)
    {Write-Output "#157 User Account Control: Admin Approval Mode for the Built-in Administrator account: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#157 User Account Control: Admin Approval Mode for the Built-in Administrator account: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableUIADesktopToggle
If ($cmd -eq 1)
    {Write-Output "#158 User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#158 User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ConsentPromptBehaviorAdmin
Write-Output "#159 User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ConsentPromptBehaviorUser
If ($cmd -eq 1)
    {Write-Output "#160 User Account Control: Behavior of the elevation prompt for standard users: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#160 User Account Control: Behavior of the elevation prompt for standard users: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").EnableInstallerDetection
If ($cmd -eq 1)
    {Write-Output "#161 User Account Control: Detect application installations and prompt for elevation: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#161 User Account Control: Detect application installations and prompt for elevation: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ValidateAdminCodeSignatures
If ($cmd -eq 1)
    {Write-Output "#162 User Account Control: Only elevate executables that are signed and validated: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#162 User Account Control: Only elevate executables that are signed and validated: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").EnableSecureUIAPaths
If ($cmd -eq 1)
    {Write-Output "#163 User Account Control: Only elevate UIAccess applications that are installed in secure locations: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#163 User Account Control: Only elevate UIAccess applications that are installed in secure locations: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").EnableLUA
If ($cmd -eq 1)
    {Write-Output "#164 User Account Control: Run all administrators in Admin Approval Mode: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#164 User Account Control: Run all administrators in Admin Approval Mode: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").PromptOnSecureDesktop
If ($cmd -eq 1)
    {Write-Output "#165 User Account Control: Switch to the secure desktop when prompting for elevation: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#165 User Account Control: Switch to the secure desktop when prompting for elevation: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").EnableVirtualization
If ($cmd -eq 1)
    {Write-Output "#166 User Account Control: Virtualize file and registry write failures to per-user locations: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#166 User Account Control: Virtualize file and registry write failures to per-user locations: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile").EnableFirewall
If ($cmd -eq 1)
    {Write-Output "#185 Firewall State (Domain Profile): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#185 Firewall State (Domain Profile): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile").EnableFirewall
If ($cmd -eq 1)
    {Write-Output "#186 Firewall State (Private Profile): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#186 Firewall State (Private Profile): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile").EnableFirewall
If ($cmd -eq 1)
    {Write-Output "#187 Firewall State (Public Profile): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#187 Firewall State (Public Profile): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"


Write-Output "#188 Turn on Mapper I/O (LLTDIO) driver:" | Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").EnableLLTDIO 
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").AllowLLTDIOOnDomain 
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").AllowLLTDIOOnPublicNet
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").ProhibitLLTDIOOnPrivateNet 
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#189 Turn on Responder (RSPNDR) driver:" |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").EnableRspndr
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").AllowRspndrOnDomain 
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").AllowRspndrOnPublicNet
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\LLTD").ProhibitRspndrOnPrivateNet
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\policies\Microsoft\Peernet").Disabled
If ($cmd -eq 1)
    {Write-Output "#190 Turn Off Microsoft Peer-to-Peer Networking Services: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#190 Turn Off Microsoft Peer-to-Peer Networking Services: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Network Connections").NC_AllowNetBridge_NLA
If ($cmd -eq 1)
    {Write-Output "#191 Prohibit installation and configuration of Network Bridge on your DNS domain network:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#191 Prohibit installation and configuration of Network Bridge on your DNS domain network:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Network Connections").NC_StdDomainUserSetLocation
If ($cmd -eq 1)
    {Write-Output "#192 Require domain users to elevate when setting a network's location:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#192 Require domain users to elevate when setting a network's location:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition").Force_Tunneling
Write-Output "#193 Route all traffic through the internal network: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition").'6to4_State'
Write-Output "#194 6to4 State: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition\IPHTTPS\IPHTTPSInterface").IPHTTPS_ClientState
If ($cmd1 -eq 3)
    {Write-Output "#195 IP-HTTPS State: DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition\IPHTTPS\IPHTTPSInterface").IPHTTPS_ClientUrl
Write-Output "#195 IP-HTTPS State: $cmd2"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition").ISATAP_State 
Write-Output "#196 ISATAP State: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TCPIP\v6Transition").Teredo_State
Write-Output "#197 Teredo State: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

Write-Output "#198 Configuration of wireless settings using Windows Connect Now:" | Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").EnableRegistrars
If ($cmd -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").DisableUPnPRegistrar
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").DisableInBand802DOT11Registrar
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").DisableFlashConfigRegistrar
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd5 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").DisableWPDRegistrar
If ($cmd5 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd5 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd6 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").MaxWCNDeviceNumber
If ($cmd6 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd6 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
$cmd7 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars").HigherPrecedenceRegistrar
If ($cmd7 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd7 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"} 
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\WCN\UI").DisableWcnUi
If ($cmd -eq 1)
    {Write-Output "#199 Prohibit Access of the Windows Connect Now wizards:  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#199 Prohibit Access of the Windows Connect Now wizards:  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Printers").DoNotInstallCompatibleDriverFromWindowsUpdate
If ($cmd -eq 1)
    {Write-Output "#200 Extend Point and Print connection to search Windows Update: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#200 Extend Point and Print connection to search Windows Update: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings").AllowRemoteRPC
If ($cmd -eq 1)
    {Write-Output "#201 Allow remote access to the Plug and Play interface: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#201 Allow remote access to the Plug and Play interface: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings").DisableSendGenericDriverNotFoundToWER
If ($cmd -eq 1)
    {Write-Output "#202 Do not send a Windows Error Report when a generic driver is installed on a device: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#202 Do not send a Windows Error Report when a generic driver is installed on a device: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings").DisableSystemRestore
If ($cmd -eq 1)
    {Write-Output "##203 Prevent creation of a system restore point during device activity that would normally prompt creation of a restore point: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "##203 Prevent creation of a system restore point during device activity that would normally prompt creation of a restore point: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata").PreventDeviceMetadataFromNetwork
If ($cmd -eq 1)
    {Write-Output "#204 Prevent device metadata retrieval from the Internet: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#204 Prevent device metadata retrieval from the Internet: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DriverSearching").SearchOrderConfig 
If ($cmd -eq 1)
    {Write-Output "#205 Specify Search Order for device driver source locations: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#205 Specify Search Order for device driver source locations: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#206 Selectively Allow the evaluation of symbolic links:" |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymLinkState
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymlinkLocalToLocalEvaluation
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymlinkLocalToRemoteEvaluation
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymlinkRemoteToRemoteEvaluation
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}

$cmd5 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Filesystems\NTFS").SymlinkRemoteToLocalEvaluation
If ($cmd5 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd5 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#207 Registry policy processing:"  |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}").NoBackgroundPolicy
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}").NoGPOListChanges
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate").DisableWindowsUpdateAccess
If ($cmd -eq 1)
    {Write-Output "#208 Turn off access to all Windows Update features: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#208 Turn off access to all Windows Update features: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Printers").DisableWebPnPDownload
If ($cmd -eq 1)
    {Write-Output "#209 Turn off downloading of print drivers over HTTP: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#209 Turn off downloading of print drivers over HTTP: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\EventViewer").MicrosoftEventVwrDisableLinks
If ($cmd -eq 1)
    {Write-Output "#210 Turn off Event Viewer Events.asp links: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#210 Turn off Event Viewer Events.asp links: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TabletPC").PreventHandwritingDataSharing
If ($cmd -eq 1)
    {Write-Output "#211 Turn off handwriting personalization data sharing: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#211 Turn off handwriting personalization data sharing: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\TabletPC").PreventHandwritingDataSharing
If ($cmd -eq 1)
    {Write-Output "#212 Turn off handwriting recognition error reporting: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#212 Turn off handwriting recognition error reporting: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc").Headlines
If ($cmd -eq 1)
    {Write-Output "#213 Turn off Help and Support Center (Did you know?) content: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#213 Turn off Help and Support Center (Did you know?) content: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc").MicrosoftKBSearch
If ($cmd -eq 1)
    {Write-Output "#214 Turn off Help and Support Center Microsoft Knowledge Base search: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#214 Turn off Help and Support Center Microsoft Knowledge Base search: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Internet Connection Wizard").ExitOnMSICW
If ($cmd -eq 1)
    {Write-Output "#215 Turn off Internet Connection Wizard if URL connection is referring to Microsoft.com: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#215 Turn off Internet Connection Wizard if URL connection is referring to Microsoft.com: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoWebServices
If ($cmd -eq 1)
    {Write-Output "#216 Turn off Internet download for Web publishing and online ordering wizards: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#216 Turn off Internet download for Web publishing and online ordering wizards: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoInternetOpenWith
If ($cmd -eq 1)
    {Write-Output "#217 Turn off Internet File Association service: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#217 Turn off Internet File Association service: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Printers").DisableHTTPPrinting
If ($cmd -eq 1)
    {Write-Output "#218 Turn off printing over HTTP: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#218 Turn off printing over HTTP: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Registration Wizard Control").NoRegistration
If ($cmd -eq 1)
    {Write-Output "#219 Turn off Registration if URL connection is referring to Microsoft.com: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#219 Turn off Registration if URL connection is referring to Microsoft.com: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\SearchCompanion").DisableContentFileUpdates
If ($cmd -eq 1)
    {Write-Output "#220 Turn off Search Companion content file updates: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#220 Turn off Search Companion content file updates: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoOnlinePrintsWizard
If ($cmd -eq 1)
    {Write-Output "#221 Turn off the Order Prints picture task: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#221 Turn off the Order Prints picture task: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoPublishingWizard
If ($cmd -eq 1)
    {Write-Output "#222 Turn off the Publish to Web task for files and folders: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#222 Turn off the Publish to Web task for files and folders: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Messenger\Client").CEIP
Write-Output "#223 Turn off the Windows Messenger Customer Experience Improvement Program: $cmd" |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\SQMClient\Windows").CEIPEnable
If ($cmd -eq 1)
    {Write-Output "#224 Turn off Windows Customer Experience Improvement Program: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#224 Turn off Windows Customer Experience Improvement Program: DISABLED" | Out-File -Append "$file"}
elseif ($cmd > 2)
    {Write-Output "#224 Turn off Windows Customer Experience Improvement Program: UNKNOWN FURHTER INVESTIGATION NEEDED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#225 Turn off Windows Error Reporting:"   |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting").DoReport
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting").Disabled 
If ($cmd2 -eq 1)

    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\DriverSearching").DontSearchWindowsUpdate
If ($cmd -eq 1)
    {Write-Output "#226 Turn off Windows Update device driver searching: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#226 Turn off Windows Update device driver searching: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").LogonType
If ($cmd -eq 1)
    {Write-Output "#227 Always use classic logon: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#227 Always use classic logon: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").DisableLocalMachineRunOnce
If ($cmd -eq 1)
    {Write-Output "#228 Do not process the run once list: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#228 Do not process the run once list: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51").DCSettingIndex
If ($cmd -eq 1)
    {Write-Output "#229 Require a Password When a Computer Wakes (On Battery): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#229 Require a Password When a Computer Wakes (On Battery): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51").ACSettingIndex
If ($cmd -eq 1)
    {Write-Output "##230 Require a Password When a Computer Wakes (Plugged In): ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "##230 Require a Password When a Computer Wakes (Plugged In): DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKEY_LOCAL_MACHINE:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364\DCSettingIndex").3600 
Write-Output "#231 Specify the System Hibernate Timeout (On Battery): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKEY_LOCAL_MACHINE:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364\ACSettingIndex").3600
Write-Output "#232 Specify the System Hibernate Timeout (Plugged In): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKEY_LOCAL_MACHINE:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364\DCSettingIndex").1200
Write-Output "#233 Turn off the Display (On Battery): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKEY_LOCAL_MACHINE:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364\ACSettingIndex").1200
Write-Output "#234 Turn off the Display (On Battery): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

Write-Output "#235 Offer Remote Assistance:"  |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fAllowUnsolicited
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fAllowUnsolicitedFullControl
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd3 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services\RAUnsolicit")
Write-Output `n | Out-File -Append "$file"

Write-Output "#236 Solicited Remote Assistance:"  |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fAllowToGetHelp
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fAllowFullControl
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd3 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").MaxTicketExpiry 
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd4 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").MaxTicketExpiryUnits 
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd5 = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").fUseMailto 
If ($cmd5 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd5 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services").LoggingEnabled
If ($cmd -eq 1)
    {Write-Output "#237 Turn on session logging: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#237 Turn on session logging: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Rpc").RestrictRemoteClients
If ($cmd -eq 1)
    {Write-Output "#238 Restrictions for Unauthenticated RPC clients: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#238 Restrictions for Unauthenticated RPC clients: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows NT\Rpc").EnableAuthEpResolution
If ($cmd -eq 1)
    {Write-Output "#239 RPC Endpoint Mapper Client Authentication: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#239 RPC Endpoint Mapper Client Authentication: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy").DisableQueryRemoteServer
If ($cmd -eq 1)
    {Write-Output "#240 Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#240 Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy").EnableQueryRemoteServer
If ($cmd -eq 1)
    {Write-Output "#241 Troubleshooting: Allow users to access online troubleshooting content on Microsoft servers from the Troubleshooting Control Panel (via the Windows Online Troubleshooting Service - WOTS):  ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#241 Troubleshooting: Allow users to access online troubleshooting content on Microsoft servers from the Troubleshooting Control Panel (via the Windows Online Troubleshooting Service - WOTS):  DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}").ScenarioExecutionEnabled
If ($cmd -eq 1)
    {Write-Output "#242 Enable/Disable PerfTrack: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#242 Enable/Disable PerfTrack: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\W32time\Parameters").NtpServer
If ($cmd -eq 1)
    {Write-Output "#243 Configure Windows NTP Client\NtpServer: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#243 Configure Windows NTP Client\NtpServer: DISABLED" | Out-File -Append "$file"}
esle ($cmd -eq "IsNull")(NpServer) 
    {Write-Output "#243 Configure Windows NTP Client\NtpServer: Does not exsit" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\AppCompat").DisableInventory
If ($cmd -eq 1)
    {Write-Output "#244 Turn off Program Inventory: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#244 Turn off Program Inventory: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoAutorun
If ($cmd -eq 1)
    {Write-Output "#245 Default behavior for AutoRun: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#245 Default behavior for AutoRun: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoDriveTypeAutoRun
Write-Output "#246 Turn off Autoplay: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Explorer").NoAutoplayfornonVolume
If ($cmd -eq 1)
    {Write-Output "#247 Turn off Autoplay for non-volume devices: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#247 Turn off Autoplay for non-volume devices: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI").EnumerateAdministrators
If ($cmd -eq 1)
    {Write-Output "#248 Enumerate administrator accounts on elevation: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#248 Enumerate administrator accounts on elevation: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar").OverrideMoreGadgetsLink
Write-Output "#249 Override the More Gadgets link: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar").TurnOffUnsignedGadgets
If ($cmd -eq 1)
    {Write-Output "#250 Restrict unpacking and installation of gadgets that are not digitally signed: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#250 Restrict unpacking and installation of gadgets that are not digitally signed: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar").TurnOffUserInstalledGadgets
If ($cmd -eq 1)
    {Write-Output "#251 Turn Off user-installed desktop gadgets: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#251 Turn Off user-installed desktop gadgets: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Digital Locker").DoNotRunDigitalLocker
If ($cmd -eq 1)
    {Write-Output "#252 Do not allow Digital Locker to run: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#252 Do not allow Digital Locker to run: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application").AutoBackupLogFiles
If ($cmd -eq 1)
    {Write-Output "#253 Backup log files automatically when full: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#253 Backup log files automatically when full: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application").MaxSize
Write-Output "#254 Maximum Log Size (KB): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application").Retention
If ($cmd -eq 1)
    {Write-Output "#255 Retain old events: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#255 Retain old events: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security").AutoBackupLogFiles
If ($cmd -eq 1)
    {Write-Output "#256 Backup log files automatically when full: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#256 Backup log files automatically when full: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security").MaxSize
Write-Output "#257 Maximum Log Size (KB): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security").Retention
If ($cmd -eq 1)
    {Write-Output "#258 Retain old events: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#258 Retain old events: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup").MaxSize
Write-Output "#259 Maximum Log Size (KB): $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\System").AutoBackupLogFiles
If ($cmd -eq 1)
    {Write-Output "#260 Backup log files automatically when full: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#260 Backup log files automatically when full: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\System").MaxSize
Write-Output "#261 Maximum Log Size (KB): $cmd "  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\EventLog\System").Retention 
If ($cmd -eq 1)
    {Write-Output "#262 Retain old events: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#262 Retain old events: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\GameUX").DownloadGameInfo
If ($cmd -eq 1)
    {Write-Output "#263 Turn off downloading of game information: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#263 Turn off downloading of game information:: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\GameUX").GameUpdateOptions
If ($cmd -eq 1)
    {Write-Output "#264 Turn off game updates: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#264 Turn off game updates: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\HomeGroup").DisableHomeGroup
If ($cmd -eq 1)
    {Write-Output "#265 Prevent the computer from joining a homegroup: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#265 Prevent the computer from joining a homegroup: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Conferencing").NoRDS
If ($cmd -eq 1)
    {Write-Output "#266 Disable remote Desktop Sharing: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#266 Disable remote Desktop Sharing: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fDenyTSConnections
If ($cmd -eq 1)
    {Write-Output "#267 Allow users to connect remotely using Remote Desktop Services: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#267 Allow users to connect remotely using Remote Desktop Services: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fDisableCcm 
If ($cmd -eq 1)
    {Write-Output "#268 Do not allow COM port redirection: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#268 Do not allow COM port redirection: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fDisableCdm
If ($cmd -eq 1)
    {Write-Output "#269 Do not allow drive redirection: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#269 Do not allow drive redirection: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fDisablePNPRedir
If ($cmd -eq 1)
    {Write-Output "#270 Do not allow supported Plug and Play device redirection: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#270 Do not allow supported Plug and Play device redirection: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fNoRemoteDesktopWallpaper
If ($cmd -eq 1)
    {Write-Output "#271 Enforce Removal of Remote Desktop Wallpaper: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#271 Enforce Removal of Remote Desktop Wallpaper: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fPromptForPassword 
If ($cmd -eq 1)
    {Write-Output "#271 Enforce Removal of Remote Desktop Wallpaper: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#271 Enforce Removal of Remote Desktop Wallpaper: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fEncryptRPCTraffic
If ($cmd -eq 1)
    {Write-Output "#273 Require secure RPC communication: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#273 Require secure RPC communication: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").SecurityLayer
If ($cmd -eq 1)
    {Write-Output "#274 Require use of specific security layer for remote (RDP) connections: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#274 Require use of specific security layer for remote (RDP) connections: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").MinEncryptionLevel
If ($cmd -eq 1) 
    {Write-Output "#275 Set client connection encryption level: LOW" | Out-File -Append "$file"}
If ($cmd -eq 2) 
    {Write-Output "#275 Set client connection encryption level: CLIENT COMPATIBLE" | Out-File -Append "$file"}
If ($cmd -eq 3)
    {Write-Output "#275 Set client connection encryption level: HIGH LEVEL" | Out-File -Append "$file"}
If ($cmd -eq 4) 
    {Write-Output "#275 Set client connection encryption level: FIPSL" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").MaxIdleTime
Write-Output "#276 Set time limit for active but idle Remote Desktop Services sessions: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").MaxDisconnectionTime
Write-Output "#277 Set time limit for disconnected sessions: $cmd" | Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").fResetBroken
If ($cmd -eq 1)
    {Write-Output "#278 Terminate session when time limits are reached: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#278 Terminate session when time limits are reached: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").DeleteTempDirsOnExit
If ($cmd -eq 1)
    {Write-Output "#279 Do not delete temp folder upon exit: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#279 Do not delete temp folder upon exit: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").PerSessionTempDir
If ($cmd -eq 1)
    {Write-Output "#280 Do not use temporary folders per session: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#280 Do not use temporary folders per session: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").DisablePasswordSaving
If ($cmd -eq 1)
    {Write-Output "#281 Do not allow passwords to be saved: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#281 Do not allow passwords to be saved: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds").DisableEnclosureDownload
If ($cmd -eq 1)
    {Write-Output "#282 Turn off downloading of enclosures: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#282 Turn off downloading of enclosures: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search").AllowIndexingEncryptedStoresOrItems
If ($cmd -eq 1)
    {Write-Output "#283 Allow indexing of encrypted files: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#283 Allow indexing of encrypted files: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search").PreventIndexingUncachedExchangeFolders
If ($cmd -eq 1)
    {Write-Output "#284 Enable indexing uncached Exchange folders: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#284 Enable indexing uncached Exchange folders: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\WAU").Disabled
If ($cmd -eq 1)
    {Write-Output "#285 Prevent Windows Anytime Upgrade from running: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#285 Prevent Windows Anytime Upgrade from running: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows Defender").SpyNetReporting
If ($cmd -eq 1)
    {Write-Output "#286 Configure Microsoft Spynet Reporting: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#286 Configure Microsoft Spynet Reporting: DISABLED" | Out-File -Append "$file"}
rite-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows Defender").DisableAntiSpyware
If ($cmd -eq 1)
    {Write-Output "#287 Turn off Windows Defender: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#287 Turn off Windows Defender: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting").LoggingDisabled
If ($cmd -eq 1)
    {Write-Output "#288 Disable Logging: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#288 Disable Logging: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting").Disabled
If ($cmd -eq 1)
    {Write-Output "#289 Disable Windows Error Reporting: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#289 Disable Windows Error Reporting: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#290 Display Error Notification:" | Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting").ShowUI
if ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW").DWAllowHeadless
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting").DontSendAdditionalData
If ($cmd -eq 1)
    {Write-Output "#291 Do not send additional data: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#291 Do not send additional data: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Explorer").NoDataExecutionPrevention
If ($cmd -eq 1)
    {Write-Output "#292 Turn off Data Execution Prevention for Explorer: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#292 Turn off Data Execution Prevention for Explorer: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Explorer").NoHeapTerminationOnCorruption
If ($cmd -eq 1)
    {Write-Output "#293 Turn off heap termination on corruption: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#293 Turn off heap termination on corruption: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").PreXPSP2ShellProtocolBehavior
If ($cmd -eq 1)
    {Write-Output "#294 Turn off shell protocol protected mode: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#294 Turn off shell protocol protected mode: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Installer").SafeForScripting
If ($cmd -eq 1)
    {Write-Output "#295 Disable IE security prompt for Windows Installer scripts: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#295 Disable IE security prompt for Windows Installer scripts: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Installer").EnableUserControl
If ($cmd -eq 1)
    {Write-Output "#296 Enable user control over installs: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#296 Enable user control over installs: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\Installer").DisableLUAPatching 
If ($cmd -eq 1)
    {Write-Output "#297 Prohibit non-administrators from applying vendor signed updates: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#297 Prohibit non-administrators from applying vendor signed updates: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ReportControllerMissing 
If ($cmd -eq 1)
    {Write-Output "#298 Report when logon server was not available during user logon: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#298 Report when logon server was not available during user logon: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows Mail").DisableCommunities
If ($cmd -eq 1)
    {Write-Output "#299 Turn off the communities features: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#299 Turn off the communities features: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SOFTWARE\Policies\Microsoft\Windows Mail").ManualLaunchAllowed
If ($cmd -eq 1)
    {Write-Output "#300 Turn off Windows Mail application: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#300 Turn off Windows Mail application: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WMDRM").DisableOnline
If ($cmd -eq 1)
    {Write-Output "#301 Prevent Windows Media DRM Internet Access: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#301 Prevent Windows Media DRM Internet Access: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer").GroupPrivacyAcceptance
If ($cmd -eq 1)
    {Write-Output "#302 Do Not Show First Use Dialog Boxes: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#302 Do Not Show First Use Dialog Boxes: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer").DisableAutoUpdate
If ($cmd -eq 1)
    {Write-Output "#303 Prevent Automatic Updates: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#303 Prevent Automatic Updates: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#304 Configure Automatic Updates: " |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").NoAutoUpdate 
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").AUOptions
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd3 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").ScheduledInstallDay
If ($cmd3 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd3 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd4 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").ScheduledInstallTime
If ($cmd4 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd4 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd =(gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").NoAUShutdownOption
If ($cmd -eq 1)
    {Write-Output "#305 Do not display 'Install Updates and Shut Down' option in Shut Down Windows dialog box: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#305 Do not display 'Install Updates and Shut Down' option in Shut Down Windows dialog box: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd =(gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").NoAutoRebootWithLoggedOnUsers
If ($cmd -eq 1)
    {Write-Output "#306 No auto-restart with logged on users for scheduled automatic updates installations: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#306 No auto-restart with logged on users for scheduled automatic updates installations: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

Write-Output "#307 Reschedule Automatic Updates scheduled installations: "  |  Out-File -Append "$file"
$cmd1 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").RescheduleWaitTimeEnabled
If ($cmd1 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd1 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
$cmd2 = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").RescheduleWaitTime
If ($cmd2 -eq 1)
    {Write-Output "ENABLED" | Out-File -Append "$file"}
elseif ($cmd2 -eq 0)
    {Write-Output "DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").UseWUServer
If ($cmd -eq 1)
    {Write-Output "#308 Specify intranet Microsoft update service location: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#308 Specify intranet Microsoft update service location: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop").ScreenSaveActive
If ($cmd -eq 1)
    {Write-Output "#309 Enable screen saver: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#309 Enable screen saver: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop").ScreenSaverIsSecure
If ($cmd -eq 1)
    {Write-Output "#310 Password protect the screen saver: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#310 Password protect the screen saver: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop").ScreenSaveTimeOut
Write-Output "#311 Screen Saver timeout: $cmd"  |  Out-File -Append "$file"
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Policies\Microsoft\Assistance\Client\1.0").NoExplicitFeedback
If ($cmd -eq 1)
    {Write-Output "#312 Turn off Help Ratings: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#312 Turn off Help Ratings: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments").SaveZoneInformation 
If ($cmd -eq 1)
    {Write-Output "#313 Do not preserve zone information in file attachments: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 2)
    {Write-Output "#313 Do not preserve zone information in file attachments: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments").HideZoneInfoOnProperties
If ($cmd -eq 1)
    {Write-Output "#314 Hide mechanisms to remove zone information: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#314 Hide mechanisms to remove zone information: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments").ScanWithAntiVirus
if ($cmd -eq 1)
    {Write-Output "#315 Notify antivirus programs when opening attachments: DISABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#315 Notify antivirus programs when opening attachments: ENABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoInplaceSharing
If ($cmd -eq 1)
    {Write-Output "#316 Prevent users from sharing files within their profile.: ENABLED" | Out-File -Append "$file"}
elseif ($cmd -eq 0)
    {Write-Output "#316 Prevent users from sharing files within their profile.: DISABLED" | Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\bthserv").start
if ($cmd -eq 2)
    {Write-Output "#323 Bluetooth Support Service: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#323 Bluetooth Support Service: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#323 Bluetooth Support Service: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\Fax").start
if ($cmd -eq 2)
    {Write-Output "#324 Fax: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#324 Fax: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#324 Fax: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\HomeGroupListener").start
if ($cmd -eq 2)
    {Write-Output "#325 HomeGroup Listener: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#325 HomeGroup Listener: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#325 HomeGroup Listener: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\HomeGroupProvider").start
if ($cmd -eq 2)
    {Write-Output "#326 HomeGroup Provider: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#326 HomeGroup Provider: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#326 HomeGroup Provider: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\Mcx2Svc").'start'
if ($cmd -eq 2)
    {Write-Output "#327 Media Center Extender Service: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#327 Media Center Extender Service: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#327 Media Center Extender Service: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\Services\WPCSvc").start
if ($cmd -eq 2)
    {Write-Output "#328 Parental Controls: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#328 Parental Controls: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#328 Parental Controls: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\BFE").start
if ($cmd -eq 2)
    {Write-Output "#329 Base Filtering Engine: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#329 Base Filtering Engine: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#329 Base Filtering Engine: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\EventSystem").Start
if ($cmd -eq 2)
    {Write-Output "#330 COM+ Event System: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#330 COM+ Event System: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#330 COM+ Event System: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\CryptSvc").start
if ($cmd -eq 2)
    {Write-Output "#331 Cryptographic Services: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#331 Cryptographic Services: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#331 Cryptographic Services: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\UxSms").start
if ($cmd -eq 2)
    {Write-Output "#332 Desktop Window Manager Session Manager: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#332 Desktop Window Manager Session Manager: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#332 Desktop Window Manager Session Manager: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Dhcp").start
if ($cmd -eq 2)
    {Write-Output "#333 DHCP Client: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#333 DHCP Client: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#333 DHCP Client: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\gpsvc").start
if ($cmd -eq 2)
    {Write-Output "#334 Group Policy Client: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#334 Group Policy Client: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#334 Group Policy Client: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\IKEEXT").start
if ($cmd -eq 2)
    {Write-Output "#335 IKE and AuthIP IPsec Keying Modules: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#335 IKE and AuthIP IPsec Keying Modules: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#335 IKE and AuthIP IPsec Keying Modules: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\iphlpsvc").start
if ($cmd -eq 2)
    {Write-Output "#336 IP Helper: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#336 IP Helper: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#336 IP Helper: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\iphlpsvc").start
if ($cmd -eq 2)
    {Write-Output "#337 Network Location Awareness: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#337 Network Location Awareness: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#337 Network Location Awareness: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\nsi").start
if ($cmd -eq 2)
    {Write-Output "#338 Network Store Interface Service: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#338 Network Store Interface Service: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#338 Network Store Interface Service: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\PlugPlay").Start
if ($cmd -eq 2)
    {Write-Output "#339 Plug and Play: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#339 Plug and Play: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#339 Plug and Play: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Power").start
if ($cmd -eq 2)
    {Write-Output "#340 Power: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#340 Power: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#340 Power: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\RpcSs").start
if ($cmd -eq 2)
    {Write-Output "#341 Remote Procedure Call (RPC): Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#341 Remote Procedure Call (RPC): Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#341 Remote Procedure Call (RPC): Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\RpcEptMapper").start
if ($cmd -eq 2)
    {Write-Output "#342 RPC Endpoint Mapper: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#342 RPC Endpoint Mapper: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#342 RPC Endpoint Mapper: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\SamSs").start
if ($cmd -eq 2)
    {Write-Output "#343 Security Accounts Manager: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#343 Security Accounts Manager: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#343 Security Accounts Manager: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\ShellHWDetection").start
if ($cmd -eq 2)
    {Write-Output "#344 Shell Hardware Detection: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#344 Shell Hardware Detection: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#344 Shell Hardware Detection: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\sppsvc").start
if ($cmd -eq 2)
    {Write-Output "#345 Software Protection: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#345 Software Protection: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#345 Software Protection: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Schedule").start
if ($cmd -eq 2)
    {Write-Output "#346 Task Scheduler: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#346 Task Scheduler: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#346 Task Scheduler: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\lmhosts").start
if ($cmd -eq 2)
    {Write-Output "#347 TCP/IP NetBIOS Helper: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#347 TCP/IP NetBIOS Helper: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#347 TCP/IP NetBIOS Helper: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\ProfSvc").start
if ($cmd -eq 2)
    {Write-Output "#348 User Profile Service: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#348 User Profile Service: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#348 User Profile Service: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\eventlog").start
if ($cmd -eq 2)
    {Write-Output "#349 Windows Event Log: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#349 Windows Event Log: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#349 Windows Event Log: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\Winmgmt").start
if ($cmd -eq 2)
    {Write-Output "#350 Windows Management Instrumentation: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#350 Windows Management Instrumentation: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#350 Windows Management Instrumentation: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$cmd = (gp "HKLM:\SYSTEM\CurrentControlSet\services\LanmanWorkstation").start
if ($cmd -eq 2)
    {Write-Output "#351 Workstation: Automatic" |  Out-File -Append "$file"}
elseif ($cmd -eq 3)
    {Write-Output "#351 Workstation: Manual" |  Out-File -Append "$file"}
elseif ($cmd -eq 4)
    {Write-Output "#351 Workstation: Disabled" |  Out-File -Append "$file"}
Write-Output `n | Out-File -Append "$file"

$error | Out-File -Append C:\temp\log_test.txt
$error.clear()
Write-Host "`nScanning $server complete"
Write-Host "Results saved: $file"