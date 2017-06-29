$smtp = "OUTLOOKEE.CA.STATE.SBU"
$to = "Email"
$cc = "Email"
$from = "Email"
$subject = "List of Computers with Passwords Set to Never Expire"
$attachment = "C:\temp\PasswordSettoNeverExpire.txt"

Get-ADComputer -Filter * -Property * | Where-Object {$_.PasswordNeverExpires -like "True"} | Format-Table -autosize -wrap Name,DistinguishedName  > C:\temp\PasswordSettoNeverExpire.txt

Send-MailMessage -To $to -Cc $cc -Subject $subject -SmtpServer $smtp -From $from -Attachment $attachment 
