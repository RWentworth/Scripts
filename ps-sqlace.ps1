$sqlserver = gc C:\temp\sqlhost
$sqlpath = @("C$\Microsoft SQL Server",
	"C$\Program Files\Microsoft SQL Server",
	"C$\Program Files (x86)\Microsoft SQL Server",
	"C$\Program Files (x86)\Microsoft SQL Server Compact Edition",
	"E$\Microsoft SQL Server",
	"E$\Program Files\Microsoft SQL Server",
	"E$\Program Files (x86)\Microsoft SQL Server",
	"F$\Microsoft SQL Server",
	"G$\Microsoft SQL Server",
	"H$\Microsoft SQL Server" )
$sqlserver | Foreach { Foreach ($s in $sqlpath) { Get-ACL \\$_\$s -Audit } } | Format-List PSPath,AuditToString