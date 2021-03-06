$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = "caew2k8webins"
$share = "C:\temp\ISSO\$server"

				$iis = Get-Service -Name "W3SVC"
				if($iis.Status -eq "Running") {
					new-item $share\ -Type Directory | Out-Null
                    $ver = (gp HKLM:\Software\Microsoft\InetStp).SetupString -split " " | Select-Object -Index 1
					Write-Output "IIS $ver is running on $server"`n`n | Out-File "$share\iis.txt"
				switch -wildcard ($ver) {
				"6.0" { $list = ("SITE","APP","VDIR","APPPOOL","CONFIG","WP","REQUEST","MODULE","BACKUP","TRACE")
                        $list | foreach { Write-Output `n -----$_-----; C:\Windows\System32\inetsrv\appcmd.exe list $_ } | Out-File -Append "$share\iis.txt" }
				"7.*" { if(Test-Path C:\Windows\System32\inetsrv\appcmd.exe) {

                        $list = ("SITE","APP","VDIR","APPPOOL","CONFIG","WP","REQUEST","MODULE","BACKUP","TRACE")
#                       $list | foreach { Write-Output `n -----$_-----; C:\Windows\System32\inetsrv\appcmd.exe list $_ } | Out-File -Append "$share\iis.txt"
						
                        } else {
						Write-Output manual verification needed | Out-File -Append "$share\iis.txt" }}
				default { echo "IIS is not running on $server" > "$share\IIS is not running on $server" }}
				} else { Write-Host "IIS is not running on $server" }