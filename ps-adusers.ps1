$stamp = (Get-Date -f HHmmss_MMddyyyy)
$date = ((Get-Date).AddDays(-1)).Date.ToString()
$loc = "\\causers\DOShare\CA ISSO Security Team\newusers\ADusers`_$stamp.csv"

$smtp = "OUTLOOKEE.CA.STATE.SBU"
$to = "<TurnerGT@state.gov>", "<BrownAJ@state.gov>"
$cc = "<bryanttn@state.gov>"
$user = $env:username + "@state.gov"
$from = $user -replace 'caadm',''
$subject = "New AD users report - 1 day(s)"

$gUsers = Get-ADUser -LDAPFilter "(!(SamAccountName=$*))(Department=CA/*)" -Properties * | Select-Object SamAccountName,Enabled,GivenName,Surname,EmailAddress,OfficePhone,Department,Company,whenCreated
$gUsers | Export-CSV -NoTypeInformation $loc

$csv = Import-CSV $loc | Where-Object { $_.whenCreated -as [datetime] -ge "$date" } | ConvertTo-HTML -Fragment
$body = "New users created in Active Directory after $date. `n `n $csv `n `n Full report: $loc"  

Send-MailMessage -BodyAsHtml -To $to -Cc $cc -Subject $subject -SmtpServer $smtp -From $from -Body $body

if ((Get-Date).DayofWeek -eq "Monday") {
    $subject = "New AD users report - 7 day(s)"
    $date = ((Get-Date).AddDays(-7)).Date.ToString()
    $csv = Import-CSV $loc | Where-Object { $_.whenCreated -as [datetime] -ge "$date" } | ConvertTo-HTML -Fragment
    $body = "New users created in Active Directory after $date. `n `n $csv `n `n Full report: $loc"  
    Send-MailMessage -BodyAsHtml -To $to -Cc $cc -Subject $subject -SmtpServer $smtp -From $from -Body $body
    }