@ECHO OFF
SET PSHOME=C:\Windows\System32\WindowsPowerShell\v1.0
%PSHOME%\powershell.exe Import-Module ActiveDirectory
SET /P U=Enter name to query: 
%PSHOME%\powershell.exe Get-ADUser -Filter 'SamAccountName -like "*%U%*"' | Select-Object SamAccountName