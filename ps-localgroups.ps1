# *** DEVELOPED BY TREVOR BRYANT, PHACIL INC ***
# *** ps-localgroups.ps1 version 1.0.0, 10/2/2014 ***
# ***  USER MUST EXECUTE AS ADMININISTRATOR  ***

$server = Get-Content "C:\temp\hostlist"
$share = "C:\temp\ISSO\localadminusers"
$loc = "$share\localgroups.csv"
$log = "$share\localgroups_log.txt"
$error.clear()
$ErrorActionPreference="SilentlyContinue"

if (! (Test-Path $share)) { new-item $share -Type directory | Out-Null }

$server | foreach { 
    #LOCAL USERS AND GROUPS
    $computer = [ADSI]("WinNT://" + $_ + ",computer")
    $groups = $computer.psbase.children | where { $_.psbase.schemaclassname -eq "group" }
    foreach ($grp in $groups) {
        $grp.psbase.Invoke("Members") | % { 
        $user = $_.GetType().InvokeMember("Adspath", 'GetProperty', $null, $_, $null)
        $ob = New-Object -TypeName PSObject -Property @{
            ComputerName = $computer.name.ToString()
            LocalGroup = $grp.name.ToString()
            Account = $user.ToString()
            } | Select-Object ComputerName,LocalGroup,Account | Export-CSV $loc -Append -NoTypeInformation 
        }
    }
}
$error | Out-File $log
Write-Output "Results saved: $loc"