#! /usr/bin

echo "########################################################"
echo "Script to harden Mac written by Richard Wentworth 7.4.17"
echo "########################################################"


echo "#########################################################################"
echo "##################### PATCHES & UPDATES #################################"
echo "#########################################################################"

echo "################[Download software updates]################"
softwareupdate --download --all

echo "################[Enable Check for Auto Updates]################"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -int 1

echo "################[Enable AutoUpdate]################"
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE

echo "################[Auto update patches]################"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true && sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

echo "################[Last Full Successful Date]################"
defaults read /Library/Preferences/com.apple.SoftwareUpdate | egrep LastFullSuccessfulDate

echo"################[Enable Install Updates]################"
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool TRUE

echo "#####################[Download software updates]#####################"
softwareupdate --download --all

echo "#####################[Enable Check for Auto Updates]#####################"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -int 1

echo "#####################[Enable AutoUpdate]#####################"
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE

echo "#####################[Auto update patches]#####################"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true && sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

echo "#####################[Last Full Successful Date]#####################"
defaults read /Library/Preferences/com.apple.SoftwareUpdate | egrep LastFullSuccessfulDate


echo "#########################################################################"
echo "##################### SOFTWARE  INSTALLS #################################"
echo "#########################################################################"

echo "################[Allow all applications download]################"
spctl --master-disable

echo "################[Install Homebrew]################"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "################[Install Brew]################" 
brew install brew-cask

echo "################[Install Chrome]################" 
brew cask install google-chrome

echo "################[Install Tor Browser]################"
brew cask install tor
mv /usr/local/etc/tor/torrc.sample /usr/local/etc/tor/torrc

echo "################[Install AVGAnti-Virus]################"
brew cask install AVGAnti-Virus

echo "################[Install Subline Text]################"
brew cask install sublime-text 

echo "################[Install CleanMyMac]################"
brew cask install cleanmymac3

echo "################[Install Gemini]################"
brew cask install Gemini

echo "################[Install Skype]################"
wget -O  skype-7-53-0-580.dmg 'https://dw.uptodown.com/dwn/xusCgvEGnRIhoR5vFrLzsMvXfzeO3JbSwxi776j3RryZtOEfZXLgss5zWo9g3jjU7kNDTTW-rzRxj4iQLzXpOCjNyi-BoLls7bgIlx9XhiROFMItMxMQwcKETGIhxB17/FdIIFCTAzzOzzzMKjnZLv93LlyF8ORBtv1Q_MgUonhNfB5eSQe7oBC2Sm9OMQXtZrpwhh98NZKDC8Aa-K3VLEdm85w8WB-MFu_szOCqop2l_o1fbbLd7ZMu1rXdyNXxo/oZAzMtxjnonAb1J8gHZ52QRYtcol8DeK7ng7R_Djo7k3G8XJUkSyEqBJnJI9dsKxYLICT4gFEoOSqF-yvVzUe7wChq9FRrGsMLi2h5nQ2eff_90E8AgI-vj4pRgqkflB/hFlNMMb3PKyuRnpoN0EFag==/'

echo "################[Install Zoom]################"
wget -O  Zoom.pkg 'https://zoom.us/download'

echo "################[Install Disk Inventory X]################"
brew cask install disk-inventory-x

echo "################[Install Wireshark]################"
brew cask install wireshark

echo "################[Install BatChmod]################" 
brew cask install BatChmod

echo "################[Install Github]################"
#brew cask installed GitHub

echo "################[Install IPVanish]################"
brew cask install ipvanish-vpn

echo "################[Install Hider]################"
brew cask install hider

echo "################[Install Opera]################" 
brew cask install Opera

echo "################[Install CCleaner]################"
brew cask install CCleaner

echo "################[Install ZENMAP]################"
brew cask install NMAP 

echo "################[Install VirtualBox]################"
brew cask install Zenmap

echo "################[Install VLC Player]################"
brew cask install VLC

echo "################[Hacking Tools]################"
$echo "Install EvilOSX" 
git clone https://github.com/Marten4n6/EvilOSX.git 
cd EvilOSX
./Server

echo "Install HashCat" 
git clone https://github.com/hashcat/hashcat.git
mkdir -p hashcat/deps
git clone https://github.com/Khronos/OpenCL -Headers.git hashcat/deps/OpenCL
cd hashcat/
make
./hashcat -m2500 -b 
./hashcat -m2500 file.hccap dictionary 

echo "################[Install Splunk via command line]################" 
wget -O splunk-7.1.1-8f0ead9ec3db-macosx-10.11-intel.dmg 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86&platform=macos&version=7.1.1&product=splunk&filename=splunk-7.1.1-8f0ead9ec3db-macosx-10.11-intel.dmg&wget=true'

echo "################[Uninstall Java]################"
sudo rm -fr /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
sudo rm -fr /Library/PreferencePanes/JavaControlPanel.prefpane

echo "################[Uninstall Flash]################"
<home directory>/Library/Preferences/Macromedia/Flash\ Player
<home directory>/Library/Caches/Adobe/Flash\ Player

echo "#########################################################################"
echo "############################## WIFI #####################################"
echo "#########################################################################"

#echo "Turn on Wifi"
#echo networksetup -setairportpower en0 on

#echo "Connect to Wifi"
#echo networksetup -setairportnetwork en0 "Wifi Name " Password 

echo "#########################################################################"
echo "##################### Bluetooth Settings ################################"
echo "#########################################################################"

echo "################[Ensure Bluetooth is off]################" 
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
sudo killall -HUP blued

echo "################[Show Bluetooth Status in Menu Bar]################" 
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

echo "################[Disable Bluetooth Sharing]################" 
echo "Verify values are Disable"
system_profiler SPBluetoothDataType | grep State
defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 0

echo "################[Remove Bluetooth support software]################" 
rm -rf /System/Library/Extensions/IOBluetoothFamily.kext
rm -rf /System/Library/Extensions/IOBluetoothHIDDriver.kext

echo "################[Turn off Bluetooh]################"
defaults write /Library/Preferences/com.apple.BluetoothControllerPowerState -int 0

echo "################[Turn off Bluetooth services]################"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.blued.plist

echo "#########################################################################"
echo "##################### Date & Time #######################################"
echo "#########################################################################"

echo "################[Ensure Network Time is On]################"
sudo systemsetup -getusingnetworktime

echo "################[Set Time Server]################"
sudo ntpdate -sv time.apple.server

echo "################[Set Screen Saver Time]################"
defaults -currentHost write com.apple.screensaver idleTime -int 1200

echo "#########################################################################"
echo "##################### System Configurations ###############################"
echo "#########################################################################"

echo "################[Disable Remote Apple Events]##########################"
sudo systemsetup -setremoteappleevents off

echo "################[Disable Internet Sharing]#############################"
echo "The file should not exist or Enabled = 0 for all network interfaces"
sudo defaults read /Library/Preferences/SystemConfiguration/com.apple.nat | grep -i Enabled

echo "################[Disable Screen Sharing]#############################"
echo "Verify the value returned is Service is disabled"
# Enable Only Screen Sharing
#sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

echo "################[Disable Printer Sharing]#############################"
lpadmin -p Printer_Name -o printer-is-shared=false

echo "################[Disable Remote Login]#############################"
sudo systemsetup -setremotelogin off

echo "################[Hide SpotLight]################"
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
killall SystemUIServer

echo "################[Disable DVD or CD Sharing]################"
echo "If com.apple.ODSAgent" appears in the result the control is not in place. No result is compliant.""
sudo launchctl list | egrep ODSAgent 
rm -f /Library/Preferences/SystemConfiguration/com.apple.ODSAgent

echo "################[Disable File Sharing]################"
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbd.plist

echo "################[screen sharing]################"
echo "Ensure /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Mac OS/ARDAgent is not present as a running process."
ps -ef | egrep ARDAgent
#echo "To Disable"
#sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool TRUE
echo "To Enable"
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false

echo "################[Disable "Wake for network access"]################" 
sudo pmset -a womp 0

echo "#########################################################################"
echo "##################### Security & Privacy ###############################"
echo "#########################################################################"

echo "################[Enable FileVault]################"
echo "Ensure FileVault is turned on"
fdesetup status
echo "Enable"
sudo fdesetup enable
#echo "Disable"
#sudo fdesetup disable

echo "################[Enable Gatekeeper]################"
sudo spctl --master-enable

echo "################[Enable Firewall]################"
defaults write /Library/Preferences/com.apple.alf globalstate -int 2

echo "################[Enable Firewall Stealth Mode]################"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

echo "################[Enable Stealth mode]################"
defaults write /Library/Preferences/com.apple.alf stealthenabled 1

echo "################[Enable Location Services]################"
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist

echo "################[Harden Wifi Settings]################" 
RequireAdminPowerToggle=YES
RequireAdminNetworkChange=YES
RequireAdminIBSS=YES

echo "################[Add Spacers To The MacOS Dock]################"
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
killall Dock

echo "################[Move Mac's Dock to the Corner]################"
defaults write com.apple.dock pinning -string end 
killall Dock

echo "################[Show Hidden Files]################"
defaults write com.apple.finder AppleShowAllFiles false
killall Dock

echo "################[Itunes Notifications]################"
defaults write com.apple.dock itunes-notifications -bool TRUE 
killall Dock

echo "################[Disable SpotLight]################"
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist.

echo "################[Allow apps downloaded from anywhere]################"
spctl --master-disable

echo "################[Enable Debug Mode]################" 
defaults write com.apple.addressbook ABShowDebugMenu -bool true
defaults write com.apple.iCal IncludeDebugMenu -bool true
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

echo "################[Disable the Startup Chime]################"
nvram SystemAudioVolume=%80

echo "################[Automatically Hide and Show Dock]################"
defaults write com.apple.Dock autohide-delay -float 0 
killall Dock

echo "################[Disable Window Animations]################"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

echo "################[Remove IR support software]################"
rm -rf /System/Library/Extensions/AppleIRController.kext

echo "################[Harden Mac OS]################"
curl -L -O http://iasecontent.disa.mil/stigs/zip/U_Apple_OS_X_10-12_V1R1_STIG.zip 
unzip U_Apple_OS_X_10-12_V1R1_STIG.zip 
cd /Users/rw/Downloads/U_Apple_OS_X_10-12_V1R1_Mobile_Configuation_Files
/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Application_Restrictions_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Bluetooth_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Custom_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Disable_iCloud_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Login_Window_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Restrictions_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Security_and_Privacy_Policy.mobileconfig


echo "################[Remove audio support software]################"
rm -rf /System/Library/Extensions/AppleUSBAudio.kext 
rm -rf /System/Library/Extensions/IOAudioFamily.kext

echo "################[Remove external FaceTime camera]################"
# srm -rf /System/Library/Extensions/Apple_iSight.kext

echo "################[Remove internal FaceTime camera]################" 
# srm -rf /System/Library/Extensions/IOUSBFamily.kext/Contents/PlugIns/AppleUSBVideoSupport.kext

echo "################[Remove USB support hardware]################"
rm -rf /System/Library/Extensions/IOUSBMassStorageClass.kext

echo "################[Use a command-line tool for secure startup]################"
nvram security-mode=full
nvram -x -p

echo "################[Change your login window access warning]################"
defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "'<You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.'"

echo "################[Enable access warning]################" 
touch /etc/motd
chmod 644 /etc/motd 
sh -c 'echo "<Warning you are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only. By using this IS (which includes any device attached to this IS), you consent to the following conditions:
-The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
-At any time, the USG may inspect and seize data stored on this IS.
-Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose.
-This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy.
-Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details.>"
>" >> /etc/motd'

echo "################[Set all “Number of Recent Items” preferences to None]################"
defaults write com.apple.recentitems Applications -dict MaxAmount 0

echo "################[Set idle time for screen saver]################"
defaults -currentHost write com.apple.screensaver idleTime -int 30

echo "################[Set host corner to turn on screen saver]################"
defaults write /Library/Preferences/com.apple.dock.wvous-dtl-corner -int 5

echo "################[Automatically hide Dock]################"
defaults write /Library/Preferences/com.apple.dock autohide -bool YES

echo "################[Display Only Active App in the Mac Dock]################"
defaults write com.apple.dock static-only -bool TRUE 
killall Dock

echo "################[Disable dashboard]################"
defaults write com.apple.dashboard mcx-disabled -boolean YES
killall

echo "################[Enable Require password to wake this computer from sleep or screen saver]################"
defaults -currentHost write com.apple.screensaver askForPassword -int 1

echo "################[Disable Automatic login]################"
defaults write /Library/Preferences/.GlobalPreferencescom.apple.userspref.DisableAutoLogin -bool yes

echo "################[Disable automatic login]################"
defaults write /Library/Preferences/.GlobalPreferencescom.apple.autologout.AutoLogOutDelay -int 0

echo "################[Enable secure virtual memory]################"
defaults write /Library/Preferences/com.apple.virtualMemoryUseEncryptedSwap -bool yes

echo "################[Disable IR remote control]################"
defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no

echo "################[Enable Firewall Loggin]################"
defaults write /Library/Preferences/com.apple.alf loggingenabled 1

echo "################[Disable VoiceOver service]################"
launchctl unload -w /System/Library/LaunchAgents/com.apple.VoiceOver.plist
launchctl unload -w /System/Library/LaunchAgents/com.apple.ScreenReaderUIServer.plist
launchctl unload -w /System/Library/LaunchAgents/com.apple.scrod.plist

echo "################[Disable internal microphone or line-in]################"
 osascript -e "set volume input volume 0"

echo "################[Disable Sync options]################"
 defaults -currentHost write com.apple.DotMacSync ShouldSyncWithServer 1

echo "################[Disable IPv6]################"
networksetup -setv6off "Wifi"
networksetup -setv6off "Bluetooth"
networksetup -setv6off "Ethernet"
networksetup -setv6off "Firewall"

echo "################[Disable fast user switching]################"
defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool 'NO'

echo "################[Set the login options to display name and password in the login window]################"
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool 'yes'

echo "################[Disable Time Machine]################"
defaults write /Library/Preferences/com.apple.TimeMachine AutoBackup 1

echo "################[Set Password Policy]################"
tpwpolicy -n /Local/Default -setglobalpolicy "minChars=10 maxFailedLoginAttempts=5"

echo "################[Disable SMB]################"
defaults delete /Library/Preferences/SystemConfiguration/com.apple.smb.server EnabledServices
launchctl unload -w /System/Library/LaunchDaemons/nmbd.plist
launchctl unload -w /System/Library/LaunchDaemons/smbd.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.smb.server.preferences.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.smb.sharepoints.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbfs_load_kext.plist
launchctl unload -w /System/Library/LaunchDaemons/org.samba.winbindd.plist

echo "################[Disable AFP]################"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.afpfs_afpLoad.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.afpfs_checkafp.plist

echo "[################[Disable NFS]################"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.nfsd.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.lockd.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.statd.notify.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.portmap.plist

echo "################[Disable web sharing]################"
launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist

echo "################[Disable Internet sharing]################"
defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
launchctl unload -w /System/Library/LaunchDaemons/com.apple.InternetSharing.plist

echo "################[Turn off Wi-Fi Services]################" 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.airportPrefsUpdater.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.AirPort.wps.plist 
launchctl unload -w /System/Library/LaunchAgents/com.apple.airportd.plist

echo "################[Turn off remote control service using the following command]################" 
launchctl unload -w /System/Library/LaunchAgents/com.apple.RemoteUI

echo "################[Turn off screen sharing services]################"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBEventHelper.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBRegisterMDNS_RemoteManagement.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBRegisterMDNS_ScreenSharing.plist 
launchctl unload -w /System/Library/LaunchAgents/com.apple.ScreenSharing.plist

echo "################[Turn off Remote Management service]################"
launchctl unload -w /System/Library/LaunchAgents/com.apple.RemoteDesktop.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RemoteDesktop.PrivilegeProxy.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBEventHelper.plist

echo "################[Enable security auditing]################"
launchctl load -w /System/Library/LaunchDaemons/com.apple.auditd.plist

echo "################[Enable mail virus screening]################"
serveradmin settings mail:postfix:virus_scan_enabled=yes

echo "################[Disable Text to Speech settings]################"
defaults write "com.apple.speech.synthesis.general.prefs" TalkingAlertsSpeakTextFlag -bool false 
defaults write "com.apple.speech.synthesis.general.prefs" SpokenNotificationAppActivationFlag -bool false 
defaults write "com.apple.speech.synthesis.general.prefs" SpokenUIUseSpeakingHotKeyFlag -bool false 
defaults delete "com.apple.speech.synthesis.general.prefs" TimeAnnouncementPrefs

echo "################[Disable Speech Recognition]################"
defaults write "com.apple.speech.recognition.AppleSpeechRecognition.prefs" StartSpeakableItems -bool false

echo "################[Enable secure virtual memory]################"
defaults write /Library/Preferences/com.apple.virtualMemoryUseEncryptedSwap -bool YES

echo "################[Enable Stealth mode]################"
defaults write /Library/Preferences/com.apple.alf stealthenabled 1

echo "################[Enable Firewall Logging]################"
defaults write /Library/Preferences/com.apple.alf loggingenabled 1

echo "################[Disable Xgrid Sharing]################"
launchctl unload -w /System/Library/Daemons/com.apple.xgridagentd
launchctl unload -w /System/Library/Daemons/com.apple.xgridcontrollerd

echo "################[Disable Remote Apple Events]################"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.eppc.plist

echo "################[Disable Remote Management]################"
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

echo "#########################################################################"
echo "##################### Application Hardening ##############################"
echo "#########################################################################"

echo "################[Harden Google Chrome]###############"
defaults write com.google.Chrome DisabledPlugins -bool true
defaults write com.google.Chrome DisabledPluginFinder -bool true
defaults write com.google.Chrome EnableOnlineRevocationChecks -bool true
defaults write com.google.Chrome IncongnitoModeAvailability -bool true
defaults write com.google.Chrome HideWebStorePromo -bool true
defaults write com.google.Chrome SafeBrowsingEnabled -bool true
defaults write com.google.Chrome SavingBrowserHistoryDisabled -bool false
defaults write com.google.Chrome DisableSpdy -bool true
defaults write com.google.Chrome Disable3DAPIs -bool true
defaults write com.google.Chrome AllowOutdatedPlugins -bool false
defaults write com.google.Chrome PaswordManagerAllowPasswords -bool false
defaults write com.google.Chrome ClearSiteDataOnExit -bool false
defaults write com.google.Chrome BackgroundModeEnabled -bool false
defaults write com.google.Chrome AlwaysAuthorizePlugins -bool false
defaults write com.google.Chrome CloudPrintProxyEnabled -bool false
defaults write com.google.Chrome AutoFillEnabled -bool false
defaults write com.google.Chrome SyncDisabled -bool true
defaults write com.google.Chrome SearchSuggestEnabled -bool false
defaults write com.google.Chrome MetericsReportingEnabled -bool false
defaults write com.google.Chrome DnsPrefetchingEnabled -bool false
defaults write com.google.Chrome SyncDisabled -bool true
defaults write com.google.Chrome ImportSavedPasswords -bool false
defaults write com.google.Chrome DefaultSearchProviderEnabled -bool true
defaults write com.google.Chrome RemoteAccessHostFirewallTraversal -bool false


echo "#########################################################################"
echo "#############################Reboot######################################"
echo "#########################################################################"

echo "#####################[Reboot]#####################"
sudo reboot
