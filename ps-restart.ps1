$log = "C:\temp\restart_log"
$server = @("CAPH958968","CAPH972578","CAPH972579","CAPH972580","CAPH972581","CAPH972583","CAPH972584","CAPH972585","CAPH972586","CAPH972582")
$server | foreach { Restart-Computer -Force $_ }
$error | Out-File $log