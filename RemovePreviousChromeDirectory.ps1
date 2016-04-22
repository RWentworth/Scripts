# Set the root directory where User Chrome is installed.
$RootDirectory= "C:\Documents and Settings\*\Local Settings\Application Data\Google\Chrome\Application\*"

#Check for HKey Users registry drive. Create if needed
if(!(Get-PSDrive -name HKU)){
    New-PSDrive HKU Registry HKEY_USERS
}
# Set Registry paths for user installed chrome. (Users who are not logged on will not be checked)
$ChomeAddRemoveKey="HKU:\S-1-5-21*\Software\Microsoft\Windows\CurrentVersion\Uninstall"
$ChromeKey= "HKU:\S-1-5-21*\Software\Google\Update"
 
# Delete all files under Chrome's user install directory
Remove-Item -recurse -force $RootDirectory

# Find and remove all user specific chrome installs from the registry.
Get-ChildItem $ChromeAddRemoveKey -ErrorAction SilentlyContinue | Where-Object {($_.PSChildName -eq 'Google Chrome') -or ($_.PSChildName -eq 'Chrome')} | Remove-Item -force
Get-ChildItem $ChromeKey -ErrorAction SilentlyContinue -recurse | Where-Object {($_.PSChildName -eq '{8A69D345-D564-463c-AFF1-A69D9E530F96}') -or 
    ($_.PSChildName -eq '{00058422-BABE-4310-9B8B-B8DEB5D0B68A}')} | Remove-Item -force
