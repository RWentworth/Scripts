# *** DEVELOPED BY TREVOR BRYANT, PHACIL INC ***
# *** ps-iis.ps1 version 1.0.0, 4/6/2015 ***
# ***  USER MUST EXECUTE AS ADMININISTRATOR  ***

$user = whoami
Write-Output "Executed by $user on device $server"

Import-Module WebAdministration,ServerManager
$iisver = (gp "HKLM:\Software\Microsoft\InetStp").SetupString
Write-Output "This server is running $iisver."

Write-Output `n "1)"
Write-Output "Physical verification required"
Write-Output `n "2)"
(gwmi Win32_OperatingSystem).Caption
Write-Output `n "3)"
gp "HKLM:\Software\DOS\Templates\*" | where { $_.Description -Like "*" } | FT -AutoSize Description,CurrentVer
Write-Output `n "4)"
Get-PSDrive -PSProvider FileSystem | FT -AutoSize | Out-String
Write-Output `n "5)"
Get-Webapplication | FT -Autosize
Write-Output `n "6)"
Write-Output "See item #3"
Write-Output `n "7)"
Get-WindowsFeature | where { $_.Installed -eq 'True' } | FT -Autosize | Out-String
Write-Output `n "8)"
(gwmi Win32_OperatingSystem).CSDVersion
Write-Output `n "9)"
Get-WebBinding | Select bindingInformation | Out-String
Write-Output `n "10)"
Write-Output "See form DS-3081 for this server."
Write-Output `n "11)"
Write-Output "Interview question"
Write-Output `n "12)"
Write-Output "Definitions managed by SEPM."
Write-Output `n "13)"
Write-Output "Manual verification needed."
Write-Output `n "14)"
Write-Output "Requirement satisfied."
Write-Output `n "15)"
(gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*) | Sort DisplayName | FT -Autosize DisplayName,DisplayVersion
Write-Output `n "16)"
Write-Output "If the computer is joined to OpenNet, the policy disallows users outside the Administrator group from logging in."
Write-Output `n "17)"
$admins = [ADSI]"WinNT://./Administrators"
@($admins.Invoke("Members")) | foreach { $_.GetType().InvokeMember("Name", 'GetProperty', $null,$_, $null) }
Write-Output `n "18)"
Write-Output "See item #17"
Write-Output `n "19)"
Write-Output "See item #17"
Write-Output `n "20)"
Write-Output "Manual verification needed."
Write-Output `n "21)"
Write-Output "See item #7"
Write-Output `n "22)"
Write-Output "See item #7"
Write-Output `n "23)"
Get-WindowsFeature | where { $_.Name -Like '*FTP*' } | FT -Autosize | Out-String
C:\Windows\System32\inetsrv\appcmd.exe list config /section:? | select-string -pattern "ftp" | foreach { C:\Windows\System32\inetsrv\appcmd.exe list config /section:$_ }
Write-Output `n "24)"
Write-Output "If FTP Publishing Service is enabled and the server is NOT external facing, the requirement is satisfied."
Write-Output `n "25)"
Write-Output "See item #24"
Write-Output `n "26)"
Get-WebApplication | FT -Autosize path,enabledProtocols | Out-String
Write-Output `n "27)"
C:\Windows\System32\inetsrv\appcmd.exe list config /section:windowsAuthentication
Write-Output `n "28)"
C:\Windows\System32\inetsrv\appcmd.exe list config /section:httpErrors
Write-Output `n "29)"
Write-Output "See item #28 for any custom error pages."
Write-Output `n "30)"
Get-WebConfiguration /system.webServer/handlers/* -Recurse | FT -Autosize Name,Verb,ElementTagName | Out-String
Write-Output `n "31)"
Write-Output "See item #30"
Write-Output `n "32)"
C:\Windows\System32\inetsrv\appcmd.exe list config /section:httpProtocol
Write-Output `n "33)"
C:\Windows\System32\inetsrv\appcmd.exe list config /section:isapiCgiRestriction
Write-Output `n "34)"
Write-Output "See item #33"
Write-Output `n "35)"
Write-Output "See ITCCB approved CGI or ISAPS extensions required by the specific application."
Write-Output `n "36)"
Get-WebConfiguration /system.applicationHost/log/* | FT -Autosize elementTagName,Directory | Out-String
Write-Output `n "37)"
Write-Output "See item #36"
Write-Output `n "38)"
Get-WebConfiguration /system.applicationHost/log/* | FT -Autosize elementTagName,period | Out-String
Write-Output `n "39)"
Get-WebConfiguration /system.applicationhost/sites/sitedefaults/logfile | Select-Object -ExpandProperty logExtFileFlags | Out-String
Write-Output `n "40)"
Get-WebConfiguration /system.webServer/staticContent/* | FT -Autosize mimeType,fileExtension | Out-String
Write-Output `n "41)"
Get-WebConfiguration /system.webServer/caching | FT -Autosize maxCacheSize
Write-Output `n "42)"
Get-WebConfiguration /system.webServer/caching | FT -Autosize maxResponseSize
Write-Output `n "43)"
gci Cert:\LocalMachine | FT -Autosize Name,Certificates,Location | Out-String
Write-Output `n "44)"
Write-Output "Check manually" #???
Write-Output `n "45)"
Write-Output "Check manually" #???
Write-Output `n "46)"
Write-Output "See item #17"
Write-Output `n "47)"
Write-Output "Check manually" #???
Write-Output `n "48)"
$admins = [ADSI]"WinNT://./Administrators"
@($admins.Invoke("Members")) | foreach { $_.GetType().InvokeMember("Adspath", 'GetProperty', $null,$_, $null) }
Write-Output `n "49)"
C:\Windows\System32\inetsrv\appcmd.exe list config /section:? | select-string -pattern "log" | foreach { C:\Windows\System32\inetsrv\appcmd.exe list config /section:$_ }
Write-Output `n "50)"
C:\Windows\System32\inetsrv\appcmd.exe list config /section:configurationRedirection
Write-Output `n "51)"
Write-Output "Check manually" #???
Write-Output `n "52)"
Write-Output "Manual verification needed."
Write-Output `n "53)"
Write-Output "Check manually" #???
Write-Output `n "54)"
gci IIS:\AppPools | FT -Autosize | Out-String
Write-Output `n "55)"
gci IIS:\AppPools | FT -Autosize Name,queueLength | Out-String
Write-Output `n "56)"
C:\Windows\System32\inetsrv\appcmd.exe list apppool /text:processModel.identityType
Write-Output `n "57)"
C:\Windows\System32\inetsrv\appcmd.exe list apppool /text:processModel.idleTimeout
Write-Output `n "58)"
C:\Windows\System32\inetsrv\appcmd.exe list apppool /text:failure.orphanWorkerProcess
Write-Output `n "59)"
C:\Windows\System32\inetsrv\appcmd.exe list apppool /text:failure.rapidFailProtection
Write-Output `n "60)"
C:\Windows\System32\inetsrv\appcmd.exe list apppool /text:failure.rapidFailProtectionInterval
Write-Output `n "61)"
C:\Windows\System32\inetsrv\appcmd.exe list apppool /text:failure.rapidFailProtectionMaxCrashes
Write-Output `n "62)"
C:\Windows\System32\inetsrv\appcmd.exe list apppool /text:recycling.periodicRestart.privateMemory
Write-Output `n "63)"
C:\Windows\System32\inetsrv\appcmd.exe list apppool /text:recycling.periodicRestart.time
Write-Output `n "64)"
C:\Windows\System32\inetsrv\appcmd.exe list apppool /text:recycling.periodicRestart.requests
Write-Output `n "65)"
Write-Output "Check manually" #???
Write-Output `n "66)"
gci IIS:/Sites | FT -Autosize name,physicalPath
Write-Output `n "67)"
Write-Output "Check manually" #???
Write-Output `n "68)"
Write-Output "See item #69"
Write-Output `n "69)"
(Get-ACL C:\inetpub).AccessToString
Write-Output `n "70)"
C:\Windows\System32\inetsrv\appcmd.exe list vdir /text:physicalPath
Write-Output `n "71)"
Write-Output "See item #70"
Write-Output `n "72)"
Write-Output "Check manually" #???
Write-Output `n "73)"
C:\Windows\System32\inetsrv\appcmd.exe list site /text:limits.maxConnections
Write-Output `n "74)"
Get-WebBinding | select -expand bindingInformation | %{$_.split(':')[-1]}
Write-Output `n "75)"
Write-Output "See item #66"
Write-Output `n "76)"
Write-Output "Check manually" #???
Write-Output `n "77)"
Write-Output "Check manually" #???
Write-Output `n "78)"
C:\Windows\System32\inetsrv\appcmd.exe list site /text:ftpServer.connections.maxConnections
Write-Output `n "79)"
C:\Windows\System32\inetsrv\appcmd.exe list site /text:ftpServer.logFile.enabled
Write-Output `n "80)"
C:\Windows\System32\inetsrv\appcmd.exe list site /text:ftpServer.logFile.logExtFileFlags
Write-Output `n "81)"
Write-Output "Check manually" #???
Write-Output `n "82)"
C:\Windows\System32\inetsrv\appcmd.exe list site /text:ftpServer.messages.greetingMessage
C:\Windows\System32\inetsrv\appcmd.exe list site /text:ftpServer.messages.bannerMessage
Write-Output `n "83)"
Write-Output "Check manually" #???
Write-Output `n "84)"
Write-Output "Check manually" #??? #secedit stuff
Write-Output `n "85)"
Write-Output "See item #7"
Write-Output `n "86)"
Write-Output "Check manually" #???
Write-Output `n "87)"
Write-Output "Check manually" #???
Write-Output `n "88)"
Write-Output "Check manually" #???
Write-Output `n "89)"
Write-Output "Check manually" #???
Write-Output `n "90)"
C:\Windows\System32\inetsrv\appcmd.exe list site /text:ftpServer.logFile.period
Write-Output `n "91)"
Write-Output "See item #80"