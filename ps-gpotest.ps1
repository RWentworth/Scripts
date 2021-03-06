$server = hostname
$AD = Get-ADComputer $server
$ADj = ($AD.DistinguishedName.Split(",")[1..7] | foreach { $_ }) -join ','
$domain = (gwmi Win32_ComputerSystem -CN $server -namespace "root\CIMV2").Domain
$GPi = (Get-GPInheritance -Target $ADj).InheritedGpoLinks | FT -Hide DisplayName
$GPi | foreach { Get-GPOReport -Name "$_" -Domain $domain -ReportType HTML C:\temp\ISSO\"$_".html }