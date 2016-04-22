Get-ADGroup "Domain Computers" -Property Members | Select -ExpandProperty Members | ForEach {
              Get-ADUser "$_" | Select  SamAccountName,Name
}

