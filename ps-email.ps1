$server = hostname
$smtp = "OUTLOOKEE.CA.STATE.SBU"
$to = "bryanttn@state.gov"
$cc = "wentworthrh@state.gov"
$from = "bryanttn@state.gov"
$subject = "Scanned: $server"
$attachment = "$filepath\$name"

$IPa = [System.Net.DNS]::GetHostAddresses("$server")
$AD = Get-ADComputer $server
$Obj1 = New-Object -TypeName PSObject
$Obj1 | Add-Member -MemberType noteproperty -name 'ComputerName' -value $server
$Obj1 | Add-Member -MemberType noteproperty -name 'IP Address' -value $IPa[0].IPAddressToString
$Obj1 | Add-Member -MemberType noteproperty -name 'AD Path' -value $AD.DistinguishedName

Send-MailMessage -To $to -Cc $cc -Subject $subject -SmtpServer $smtp -From $from -Body $Obj1