
$server = GC "C:\temp\caez"
$cred = Get-Credential

$server | foreach {
    Write-Host "$_ : Copying file and executing installation..."
    Copy-Item "C:\Users\bryanttn\Downloads\20141027-032-v5i64.exe" "\\$_\C$\temp" -Force
    Set-Content "\\$_\C$\temp\installme.bat" -Value "C:\temp\20141027-032-v5i64.exe /q"
    Invoke-Command -CN $_ -Credential $cred -ScriptBlock { & cmd.exe /c "C:\temp\installme.bat" }
    Write-Host "$_ : Copy and installation complete."
}
$server
$error
