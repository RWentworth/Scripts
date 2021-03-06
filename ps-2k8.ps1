#SET VARS
$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = hostname
$share = "C:\ISSO\$server`_$timestamp"
$log="$share\log.txt"

#DEFINE FUNCTIONS USED

function Get-InstalledSoftware {
param (
    [parameter(mandatory=$true)][array]$ComputerName )
        foreach ($Computer in $ComputerName) {
            $OSArchitecture = (Get-WMIObject -ComputerName $Computer win32_operatingSystem -ErrorAction Stop).OSArchitecture
            if ($OSArchitecture -like '*64*') {
                [array]$RegistryPath = 'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall','Software\Microsoft\Windows\CurrentVersion\Uninstall'
            } else {
                [array]$RegistryPath = 'Software\Microsoft\Windows\CurrentVersion\Uninstall'
            }
            $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Computer)
            $Array = @()
            foreach ($RegPath in $RegistryPath) {
                $RegistryKey = $Registry.OpenSubKey("$RegPath")
                $RegistryKey.GetSubKeyNames() | foreach {
                $Registry.OpenSubKey("$RegPath\$_") | Where-Object {($_.GetValue("DisplayName") -notmatch '(KB[0-9]{6,7})') -and ($_.GetValue("DisplayName") -ne $null)} | foreach {
                    $Object = New-Object -TypeName PSObject
                    $Object | Add-Member -MemberType noteproperty -name 'ComputerName' -value $Computer
                    $Object | Add-Member -MemberType noteproperty -Name 'Name' -Value $($_.GetValue("DisplayName"))
                    $Object | Add-Member -MemberType noteproperty -Name 'Version' -Value $($_.GetValue("DisplayVersion"))
#                   $Object | Add-Member -MemberType noteproperty -Name 'Publisher' -Value $($_.GetValue("Publisher"))
                    $Object 
                } 
            }
        } 
    } 
} 

#START SCAN
Write-Host "`nScanning" $server
	if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }

	#DETERMINE OS VERSION AND DO WORK
	$OSver = (gwmi -class Win32_OperatingSystem).Version
	$OS = (gwmi -class Win32_OperatingSystem).Caption
	$OSr = $OSver.remove(3)
	switch -wildcard ($OSr) {
		"5.*" { ECHO "$server is: $OS$OSver" >> "$share\OS_$server.txt" }
		"6.0" { ECHO "$server is: $OS$OSver" >> "$share\OS_$server.txt" }
		"6.1" { ECHO "$OS$OSver" >> "$share\OS_$server.txt"
				
				#LOCAL USERS AND GROUPS - #28, 29, 31, 45
				$computer = [ADSI]("WinNT://" + $server + ",computer")
				$computer.name > "$share\localgroups_$server.txt"
				echo `n >> "$share\localgroups_$server.txt"
				$group = $computer.psbase.children | where{$_.psbase.schemaclassname -eq "group"}
				foreach ($member in $group.psbase.syncroot){
					$g=$member.name 
					echo --------------------------`n"GROUP:"$g >> "$share\localgroups_$server.txt"
					$g2 =[ADSI]"WinNT://$server/$g"
					$members = @($g2.psbase.Invoke("Members"))
					$members | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) >> "$share\localgroups_$server.txt"} }
				
				gwmi -class Win32_BootConfiguration -CN $server | Format-List -Property BootDirectory,Caption,TempDirectory | Out-File -Append "$share\OS_$server.txt" #3, 6
				gwmi -class Win32_LogicalDisk -CN $server | Format-Table -AutoSize -Property DeviceID,FileSystem,SystemName | Out-File -Append "$share\OS_$server.txt" #7
				gwmi -class Win32_OperatingSystem -CN $server | Select-Object Name,OSArchitecture,Version,CSDVersion,__SERVER | Format-List | Out-File -Append "$share\OS_$server.txt" #10, 11
				gwmi -class Win32_Service -Filter 'Name="wuauserv"' -CN $server | Format-Table -AutoSize -Property Name,ProcessID,StartMode,State,Status | Out-File -Append "$share\OS_$server.txt" #71
				gwmi -class Win32_NetworkAdapterConfiguration -CN $server | Format-Table -AutoSize -Property Description,IPEnabled,DHCPEnabled,DHCPServer | Out-File -Append "$share\OS_$server.txt" 
                Get-InstalledSoftware $server | Format-Table -AutoSize | Out-File -Append "$share\OS_$server.txt"                     
				
                Get-Hotfix -CN $server | Format-Table -AutoSize | Out-File -Append "$share\OS_$server.txt" #70
                
                #12-15
				#17 - password complexity need researching
				#20 Get-NetAdapterBinding available in 2012
				#25 features of server roles
				#33, 34 research local/AD member options
			
				#50 (MSS only)
				$reg50 = @(
                "ECHO NoDriveTypeAutoRun; (Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer').NoDriveTypeAutoRun",
				"ECHO NoDefaultExempt; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\IPSEC').NoDefaultExempt",
				"ECHO WarningLevel; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\EventLog\Security').WarningLevel",
				"ECHO SafeDllSearchMode; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Session Manager').SafeDllSearchMode",
				"ECHO NtfsDisable8dot3NameCreation; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\FileSystem').NtfsDisable8dot3NameCreation",
				"ECHO ScreenSaverGracePeriod; (Get-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon').ScreenSaverGracePeriod",
				"ECHO AutoAdminLogon; (Get-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon').AutoAdminLogon",
				"ECHO TcpMaxDataRetransmissions; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters').TcpMaxDataRetransmissions",
				"ECHO TcpMaxConnectResponseRetransmissions; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters').TcpMaxConnectResponseRetransmissions",
				"ECHO SynAttackProtect; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters').SynAttackProtect",
				"ECHO PerformRouterDiscovery; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters').PerformRouterDiscovery",
				"ECHO KeepAliveTime ;(Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters').KeepAliveTime",
				"ECHO EnableICMPRedirect; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters').EnableICMPRedirect",
				"ECHO EnableDeadGWDetect; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters').EnableDeadGWDetect",
				"ECHO DisableIPSourceRouting; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters').DisableIPSourceRouting",
				"ECHO NoNameReleaseOnDemand; (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters').NoNameReleaseOnDemand" )
                Write-Output "If no value is found under the entry, the registry does not exist." | Out-File -Append "$share\OS_$server.txt"
                $reg50 | foreach { Invoke-Expression -Command $_ 2>&1 } | Out-File -Append "$share\OS_$server.txt"
                
                
				
				$reg69 = @(
				"Get-ItemProperty HKLM:\Software\JavaSoft\Java Update -Name  PolicyEnableAutoUpdateCheck"
				"Get-ItemProperty HKLM:\Software\JavaSoft\Java Update -Name  PolicyEnableAutoUpdate"
				"Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name Posix"
				"Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name Optional"
				"Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name WUServer"
				"Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name WUStatuServer"
				"Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name UseWUServer"
				"Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name NoAutoUpdate"
				"Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name AUOptions"
				"Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name DisableWindowsUpdateAccess"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server -Name Tsenabled"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server -Name fAllowtoGetheIp"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name NoNameReleaseOnDemand"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name NoNameReleaseOnDemand"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name EnabledDeadGWDetect"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name KeepAliveTime"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name PerformRouterDiscovery"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name SynAttackProtect"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name TCPMaxConnectResponseRetransmissions"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name TcpMaxHalfOpen"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name TcpMaxHalfOpenRetried"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Netbt\Parameters -Name TCPMaxPortsExhausted"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name MinEncryptionLevel"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name fInheritAutoLogon"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name fPromptForPassword"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name fInheritMaxDisconnectionTime"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name fInheritMaxIdleTime"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name fInheritMaxSessionTime"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name fInheritResetBroken"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name fResetBroken"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name fInheritShadow"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name MaxDisconnectionTime"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name MaxConnectionTime"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name MaxIdleTime"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name Shadow"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name DeleteTempDirsOnExit"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP -Name PerSessionTempDir"
				"Get-ItemProperty HKLM:\Software\JavaSoft\Java Update -Name PolicyEnableAutoUpdate"
				"Get-ItemProperty HKLM:\Microsoft\Windows\CurrentVersion -Name RunSunJavaUpdateSched"
				"Get-ItemProperty HKLM:\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{5852F5ED-8BF4-11D4-A245-0080C6F74284}"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters -Name DisabledComponents"
				"Get-ItemProperty HKLM:\Software\Policies\Microsoft\SystemCertificates\Root\ProtectedRoots -Name Flags"
				"Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion -Name ShellServiceObjectDelayLoad"
				"Get-ItemProperty HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP\UserOverride\Control Panel\Desktop' -Name Wallpaper" )
			#	$reg69 | foreach { Invoke-Expression -Command $_ 2>&1 } 
    
				cmd /c secedit /export /areas SECURITYPOLICY GROUP_MGMT USER_RIGHTS REGKEYS FILESTORE SERVICES /cfg $share\secedit_$server.txt | Out-Null #46-48, 51, 52 (research more)
				cmd /c auditpol /get /category:* > $share\auditpol_$server.txt #50
	#			cmd /c powershell Get-ClientFeature | Get-ClientFeatureInfo | Format-Table -AutoSize | Out-File C:\roles_$server.txt #23 server roles			
                
                $iis = 'Get-Service -Name "W3SVC" | Out-Null'
				if($iis.Status -eq "Running") {
					Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList ( mkdir -force $share\IIS_$server )
					$ver = (alias | powershell "reg query HKLM\Software\Microsoft\InetStp /v SetupString") -split " " | Select-Object -Index 15
					$echo = ECHO "IIS $ver is running on $server`n`n" > "C:\IIS_$server\IIS_$server.txt"
				switch -wildcard ($ver) {
				"6.0" { cmd /c ECHO 6 >> $share\IIS_$server\IIS_$server.txt }
				"7.*" { if(Test-Path C:\Windows\System32\inetsrv\appcmd.exe) {
				#		$app = "cmd /c FOR %A IN (site, app, apppool, vdir, wp, request, module, backup) DO (ECHO -----%A----- & %windir%\System32\inetsrv\appcmd.exe list %A) >> C:\IIS_$server\list_$server.txt"
						%windir%\System32\inetsrv\appcmd.exe list config > $share\IIS_$server\config_$server.txt
						} else {
						ECHO manual verification needed >> $share\IIS_$server\IIS_$server.txt }}
				default { echo "IIS is not running on $server" > "$share\IIS is not running on $server" } }
				} else { echo "IIS is not running on $server" > "$share\IIS is not running on $server" }

				

		#enumerate secpol
		if(Test-Path "$share\secedit_$server.txt"){
		$path  = "$share\secedit_$server.txt"
		$hpath = "$share\secedit_readable_$server.html"
		$text = Get-Content $path
		$header = $text | Select-String "\["
$a = @"
<style>
BODY{background-color:peachpuff;}
TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}
TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:palegoldenrod}
</style>
</head><body>
"@

for ($i = 0; $i -lt $header.length;$i++) {    
$a += @"
    <table>
    <CAPTION>$($header[$i].Line)</CAPTION>
    <colgroup>
    <col/>
    <col/>
    </colgroup>
    <tr><th>Property</th><th>Value</th></tr>
"@
		if (($i+1) -lt $header.length) {
			$text[($header[$i].LineNumber)..($header[($i+1)].LineNumber-2)] | Foreach {
				$vp = $_ -split "="
				$a += "<tr><td>$($vp[0])</td><td>$($vp[1])</td></tr>" }
		} else {
			$text[($header[$i].LineNumber)..($text.length-1)] | Foreach {
				$vp = $_ -split "="
				$a += "<tr><td>$($vp[0])</td><td>$($vp[1])</td></tr>" }
			}
		$a += "</table>" }
		$a += "</body></html>"
		$a | Out-File $hpath
		
		#find and replace SID to group name in secpol
		$original_file = "$share\secedit_readable_$server.html"
		$destination_file =  "$share\secedit_readable_$server.html"
		(Get-Content $original_file) | Foreach-Object {
			$_ -replace 'S-1-1-0', 'Everyone' `
			  -replace 'S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420', 'WdiServiceHost' `
			  -replace 'S-1-5-32-544', 'Administrators' `
			  -replace 'S-1-5-32-545', 'Users' `
			  -replace 'S-1-5-32-551', 'Backup Operators' `
			  -replace 'S-1-5-19', 'NT Authority' `
			  -replace 'S-1-5-20', 'NT Authority' `
			  -replace 'S-1-5-80-0', 'NT SERVICES\ALL SERVICES' `
			  -replace 'S-1-5-80', 'NT Service' `
			  -replace 'S-1-5-32-559', 'BUILTIN\Performance Log Users' `
			  -replace 'S-1-5-6', 'Service' `
			  -replace 'S-1-5-32-555', 'BUILTIN\Remote Desktop Users' `
			  -replace 'S-1-5-32-568', 'IIS_IUSRS' `
			} | Set-Content $destination_file }

		
                
}
} 
Write-Host "Scan complete"