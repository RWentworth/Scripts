# *** DEVELOPED BY RICHARD WENTWORTH, PHACIL INC ***
# ***  USER MUST EXECUTE AS ADMININISTRATOR  ***

$timestamp=( Get-Date -f HHmmss_MMddyyyy)
$server = hostname
$share = "C:\temp\ISSO\$server\$server`_$timestamp"
$file = "$share\$server`_$timestamp.txt"
$CMD = "C:\temp\IP.txt"

$user = whoami
Write-Output "Executed by $user on device $server" | Out-File -Append "$file"

{Foreach($system in Get-Content "$CMD");then 

[Net.DNS]::GetHostEntry("$*") | select hostname 
}
Write-Output $file

