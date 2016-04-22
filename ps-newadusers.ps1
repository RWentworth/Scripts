$stamp = (Get-Date -f HHmmss_MMddyyyy)
$date = ((Get-Date).AddDays(-1)).Date
$loc = "\\causers\DOShare\CA ISSO Security Team\newusers\ADusers`_$stamp.csv"

$smtp = "OUTLOOKEE.CA.STATE.SBU"
$to = "<TurnerGT@state.gov>", "<BrownAJ@state.gov>"
$cc = "<bryanttn@state.gov>"
$user = $env:username + "@state.gov"
$from = $user -replace 'caadm',''
$subject = "New AD users report"
$body = "New users created after $date.`n`n$loc"

#$gUsers = Get-ADUser -LDAPFilter "(!(SamAccountName=$*))" -Properties * | Where-Object { $_.whenCreated -ge $date } | Select-Object SamAccountName,Enabled,GivenName,Surname,EmailAddress,OfficePhone,Company,whenCreated
$gUsers = Get-ADUser -Filter 'SamAccountName -NotLike "$*"' -Properties * | Where-Object { $_.whenCreated -ge $date } | Select-Object SamAccountName,Enabled,GivenName,Surname,EmailAddress,OfficePhone,Company,whenCreated
$gUsers | Export-CSV -NoTypeInformation $loc

Send-MailMessage -To $to -Cc $cc -Subject $subject -SmtpServer $smtp -From $from -Body $body -Attachments $loc