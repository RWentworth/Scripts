$date = Get-Date
$loc = "C:\Users\bryanttn\Downloads\trask.jpg"

$smtp = "OUTLOOKEE.CA.STATE.SBU"
$to = "<ZelnaCT@state.gov>"
$cc = "<bryanttn@state.gov>"
$user = $env:username + "@state.gov"
$from = $user -replace 'caadm',''
$subject = "Reminder: WORK ON TRASK A&A PACKAGE!"
$body = "Reminder: WORK ON TRASK A&A PACKAGE!.`n `n $date"

$body = @' 
<html>  
  <body>  
    <img src="C:\Users\bryanttn\Downloads\trask.jpg"><br> 
   </body>  
</html>  
'@  
  
Send-MailMessage -BodyAsHtml -To $to -Cc $cc -Subject $subject -SmtpServer $smtp -From $from -Body $body -Priority High -Attachments $loc