$server = GC "C:\temp\hostlist"

Write-Host "`nScanning ... "
$server | foreach {
    Write-Host "$_`t"
    #New-Object System.Net.Sockets.TCPClient("$_",3389) -ErrorVariable sockErr | Out-Null
	#if (-not $sockerr) {  
   if(!( Test-Connection -CN $_ -BufferSize 16 -Count 1 -ea 0 -Quiet)) {
        echo "$_,Successful" | Out-File -Append C:\temp\agents.txt
    } ELSE {
        echo "$_,Unsuccessful" | Out-File -Append C:\temp\agents.txt
        } 
    } 
