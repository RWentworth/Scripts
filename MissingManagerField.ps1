$smtp = "OUTLOOKEE.CA.STATE.SBU"
$to = "Email"
$cc = "Email"
$from = "Email"
$subject = "List of Users That Dont Have the Manager Field Filled Out"
$attachment = "C:\temp\MissingManagerField.txt"

Get-ADUser -F * -PR * | Where-Object {$_.Manager -eq $null} | Format-Table -autosize -wrap Name,DistinguishedName > C:\temp\MissingManagerField.txt

Send-MailMessage -To $to -Cc $cc -Subject $subject -SmtpServer $smtp -From $from -Attachment $attachment 
