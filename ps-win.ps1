$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = Get-Content "\\caph972582\audit\winlist.txt"
$module = @("PSClientManager","PSRR","GroupPolicy","WebAdministration", "Get-InstalledSoftware")
$share = "\\caph972582\AUDIT\windows"

remove-item -recurse -force -path $share | Out-Null #temp clean up for testing

Write-Host "`nScanning ... "
$server | foreach { 
	Write-Host "$_`t"
	$loc="$share\$_\$_`_$timestamp"
	$cdr="\\$_\c$"
	$log="$share\log.txt"
	
	if (! (Test-Path $loc)) { new-item $loc -Type directory | Out-Null }
	
	start-job -name $_ -scriptblock {
	param($server, $loc, $module)
	$module | foreach { Invoke-Expression -Command "Import-Module $_" }
	
	#verify remote availability status else fail
	New-Object System.Net.Sockets.TCPClient("$server",3389) -ErrorVariable sockErr | Out-Null
	if (-not $sockerr) {
	
	#DETERMINE OS VERSION AND DO WORK
	$OSver = (gwmi -CN $server -class Win32_OperatingSystem).Version
	$OS = (gwmi -CN $server -class Win32_OperatingSystem).Caption
	$OSr = $OSver.remove(3)
	switch -wildcard ($OSr) {
		"5.*" { ECHO "$server is: $OS$OSver" >> "$loc\OS_$server.txt" }
		"6.0" { ECHO "$server is: $OS$OSver" >> "$loc\OS_$server.txt" }
		"6.1" { ECHO "$OS$OSver" >> "$loc\OS_$server.txt"
				
				#LOCAL USERS AND GROUPS - #28, 29, 31, 45
				$computer = [ADSI]("WinNT://" + $server + ",computer")
				$computer.name > "$loc\localgroups_$server.txt"
				echo `n >> "$loc\localgroups_$server.txt"
				$group = $computer.psbase.children | where{$_.psbase.schemaclassname -eq "group"}
				foreach ($member in $group.psbase.syncroot){
					$g=$member.name 
					echo --------------------------`n"GROUP:"$g >> "$loc\localgroups_$server.txt"
					$g2 =[ADSI]"WinNT://$server/$g"
					$members = @($g2.psbase.Invoke("Members"))
					$members | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) >> "$loc\localgroups_$server.txt"} }
				
				gwmi -class Win32_BootConfiguration -CN $server | Format-List -Property BootDirectory,Caption,TempDirectory | Out-File -Append "$loc\OS_$server.txt" #3, 6
				gwmi -class Win32_LogicalDisk -CN $server | Format-Table -AutoSize -Property DeviceID,FileSystem,SystemName | Out-File -Append "$loc\OS_$server.txt" #7
				gwmi -class Win32_OperatingSystem -CN $server | Select-Object Name,OSArchitecture,Version,CSDVersion,__SERVER | Format-List | Out-File -Append "$loc\OS_$server.txt" #10, 11
				gwmi -class Win32_Service -Filter 'Name="wuauserv"' -CN $server | Format-Table -AutoSize -Property Name,ProcessID,StartMode,State,Status | Out-File -Append "$loc\OS_$server.txt" #71
				gwmi -class Win32_NetworkAdapterConfiguration -CN $server | Format-Table -AutoSize -Property Description,IPEnabled,DHCPEnabled,DHCPServer | Out-File -Append "$loc\OS_$server.txt" 
#				gwmi -class Win32_Product -CN $server | Format-Table -Wrap -Property Name,Vendor,Version | Out-File -Append "$loc\OS_$server.txt"
                Get-InstalledSoftware $server | Format-Table -AutoSize | Out-File -Append "$loc\OS_$server.txt"                     
				Get-Hotfix -CN $server | Format-Table -AutoSize | Out-File -Append "$loc\OS_$server.txt" #70
                
                #12-15
				#17 - password complexity need researching
				#20 Get-NetAdapterBinding available in 2012
				#25 features of server roles
				#33, 34 research local/AD member options
			
				#50 (MSS only)
				$reg50 = @(
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Value NoDriveTypeAutoRun",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\IPSEC' -Value NoDefaultExempt",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\EventLog\Security' -Value WarningLevel",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Session Manager' -Value SafeDllSearchMode",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\FileSystem' -Value NtfsDisable8dot3NameCreation",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Value ScreenSaverGracePeriod",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Value AutoAdminLogon",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip\Parameters' -Value TcpMaxDataRetransmissions",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip\Parameters' -Value TcpMaxConnectResponseRetransmissions",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip\Parameters' -Value SynAttackProtect",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip\Parameters' -Value PerformRouterDiscovery",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip\Parameters' -Value KeepAliveTime",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip\Parameters' -Value EnableICMPRedirect",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip\Parameters' -Value EnableDeadGWDetect",
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip\Parameters' -Value DisableIPSourceRouting", 
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip\Parameters' -Value NoNameReleaseOnDemand" )
				$reg50 | foreach { Invoke-Expression -Command $_ } | Format-Table -AutoSize -Property Key,Value,Data | Out-File -Append "$loc\MMS_$server.txt"
				
				$reg69 = @(
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Software\JavaSoft\Java Update' -Value  PolicyEnableAutoUpdateCheck"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Software\JavaSoft\Java Update' -Value  PolicyEnableAutoUpdate"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Value Posix"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Value Optional"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Value WUServer"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Value WUStatuServer"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Value UseWUServer"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Value NoAutoUpdate"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Value AUOptions"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Value DisableWindowsUpdateAccess"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server' -Value Tsenabled"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server' -Value fAllowtoGetheIp"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value NoNameReleaseOnDemand"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value NoNameReleaseOnDemand"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value EnabledDeadGWDetect"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value KeepAliveTime"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value PerformRouterDiscovery"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value SynAttackProtect"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value TCPMaxConnectResponseRetransmissions"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value TcpMaxHalfOpen"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value TcpMaxHalfOpenRetried"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Netbt\Parameters' -Value TCPMaxPortsExhausted"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value MinEncryptionLevel"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value fInheritAutoLogon"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value fPromptForPassword"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value fInheritMaxDisconnectionTime"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value fInheritMaxIdleTime"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value fInheritMaxSessionTime"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value fInheritResetBroken"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value fResetBroken"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value fInheritShadow"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value MaxDisconnectionTime"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value MaxConnectionTime"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value MaxIdleTime"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value Shadow"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value DeleteTempDirsOnExit"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP' -Value PerSessionTempDir"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Software\JavaSoft\Java Update' -Value PolicyEnableAutoUpdate"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Microsoft\Windows\CurrentVersion' -Value RunSunJavaUpdateSched"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Software\Microsoft\Internet Explorer\ActiveX Compatibility\{5852F5ED-8BF4-11D4-A245-0080C6F74284}'"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Services\Tcpip6\Parameters' -Value DisabledComponents"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Software\Policies\Microsoft\SystemCertificates\Root\ProtectedRoots' -Value Flags"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'Software\Microsoft\Windows\CurrentVersion' -Value ShellServiceObjectDelayLoad"
				"Get-RegValue -CN $server -Hive LocalMachine -Key 'System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-TCP\UserOverride\Control Panel\Desktop' -Value Wallpaper" )
				$reg69 | foreach { Invoke-Expression -Command $_ } | Format-Table -AutoSize -Property Key,Value,Data | Out-File -Append "$loc\reg69_$server.txt"
			
				#INVOKED COMMANDS
				$cmd = "cmd /c secedit /export /areas SECURITYPOLICY GROUP_MGMT USER_RIGHTS REGKEYS FILESTORE SERVICES /cfg C:\secedit_$server.txt" #46-48, 51, 52 (research more)
#				Invoke-WmiMethod -Path Win32_Process -CN $server -Name Create -ArgumentList ( $cmd )
				$cmd = "cmd /c auditpol /get /category:* > C:\auditpol_$server.txt" #50
#				Invoke-WmiMethod -Path Win32_Process -CN $server -Name Create -ArgumentList ( $cmd )
				$cmd = "cmd /c powershell Get-ClientFeature | Get-ClientFeatureInfo | Format-Table -AutoSize | Out-File C:\roles_$server.txt" #23 server roles
#				Invoke-WmiMethod -Path Win32_Process -CN $server -Name Create -ArgumentList ( $cmd )				
 			
				$iis = Get-Service -CN $server -Name "W3SVC"
				if($iis.Status -eq "Running") {
					Invoke-WmiMethod -Path Win32_Process -CN $server -Name Create -ArgumentList ( mkdir -force C:\IIS_$server )
					$ver = (alias | powershell "reg query \\$server\HKLM\Software\Microsoft\InetStp /v SetupString") -split " " | Select-Object -Index 15
					$echo = ECHO "IIS $ver is running on $server`n`n" > "C:\IIS_$server\IIS_$server.txt"
				switch -wildcard ($ver) {
				"6.0" { Invoke-WmiMethod -Path Win32_Process -CN $server -Name Create -ArgumentList ( "cmd /c ECHO 6 >> C:\IIS_$server\IIS_$server.txt" )}
				"7.*" { if(Test-Path $cdr\Windows\System32\inetsrv\appcmd.exe) {
						$app = "cmd /c FOR %A IN (site, app, apppool, vdir, wp, request, module, backup) DO (ECHO -----%A----- & %windir%\System32\inetsrv\appcmd.exe list %A) >> C:\IIS_$server\list_$server.txt"
						Invoke-WmiMethod -Path Win32_Process -CN $server -Name Create -ArgumentList ( $app )
						$app = "cmd /c %windir%\System32\inetsrv\appcmd.exe list config > C:\IIS_$server\config_$server.txt"
						Invoke-WmiMethod -Path Win32_Process -CN $server -Name Create -ArgumentList ( $app )
						} else {
						Invoke-WmiMethod -Path Win32_Process -CN $server -Name Create -ArgumentList ( "cmd /c ECHO manual verification needed >> C:\IIS_$server\IIS_$server.txt" ) }}
				default { echo "IIS is not running on $server" > "$loc\IIS is not running on $server" } }
				} else { Write-Host "IIS is not running on $server" }

				#sleep and move locally created items
				Sleep 10
				if(Test-Path "$cdr\secedit_$server.txt") {move-item -path "$cdr\secedit_$server.txt" -destination "$loc\secedit_$server.txt"}
				if(Test-Path "$cdr\auditpol_$server.txt") {move-item -path "$cdr\auditpol_$server.txt" -destination "$loc\auditpol_$server.txt"}
				if(Test-Path "$cdr\roles_$server.txt") {move-item -path "$cdr\roles_$server.txt" -destination "$loc\roles_$server.txt"}
				if(Test-Path "$cdr\IIS_$server") {copy-item -recurse -path "$cdr\IIS_$server" -destination "$loc\IIS_$server"; remove-item -recurse -force -path "$cdr\IIS_$server"}
			}
		}
        
		#enumerate secpol
		if(Test-Path "$loc\secedit_$server.txt"){
		$path  = "$loc\secedit_$server.txt"
		$hpath = "$loc\secedit_readable_$server.html"
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
		$original_file = "$loc\secedit_readable_$server.html"
		$destination_file =  "$loc\secedit_readable_$server.html"
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

		#enumerate IIS config
		if(Test-Path "$loc\IIS_$server\config_$server.txt"){
		#work in progress
		}

	} else { echo "$sockerr" > "$loc\Could not connect to $server" }
		} -argumentlist $_, $loc, $module 2>&1 >> $log
} 2>&1 >> $log

do { 
$job = Invoke-Expression -Command 'Get-Job -State "Running" | Select-Object State | Select-String -pattern "Running" -quiet'
ECHO "`nWaiting for the following jobs to finish...`n"
Get-Job -State "Running"
Start-Sleep 60} while ($job -eq "True")
Get-Job | Wait-Job 2>&1 >> $log
Get-Job | Receive-Job 2>&1 >> $log
$server | foreach { (Get-Job -Name $_).JobStateInfo.Reason } 2>&1 >> $log
Remove-Job *
echo "`nAll jobs complete.`n"
#$error
