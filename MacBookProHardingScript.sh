#! /usr/bin

echo "########################################################"
echo "Script to harden Mac written by Richard Wentworth 7.4.17"
echo "########################################################"


echo "Allow all applications download"
spctl --master-disable

echo "Install Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Install Brew" 
brew install brew-cask 2>/dev/null

echo "Install Chrome" 
if find / -iname Chrome.app 2>/dev/null; then
	echo "Chome is installed"
else
	brew cask install google-chrome
fi 

echo "Install Tor Browser"
if find / -iname Tor.app 2>/dev/null; then 
	echo "Tor Browser installed"
else 
	brew cask install tor
fi 

mv /usr/local/etc/tor/torrc.sample /usr/local/etc/tor/torrc

echo "Install Subline Text"
if find / -iname sublime-text.app 2>/dev/null; then
	echo "Subline is installed"
else
	brew cask install sublime-text 
fi 

echo "Install CleanMyMac"
curl -o CleanMyMac3.dmg 'https://dl.devmate.com/com.macpaw.CleanMyMac3/CleanMyMac3.dmg?cid=1247471196.1542154531'
sudo hdiutil attach CleanMyMac3.dmg
sudo installer -package /Volumes/CleanMyMac3.dmg/CleanMyMac3.dmg.pkg -target /
sudo hdiutil detach /Volumes/CleanMyMac3.dmg

echo "Install Gemini"
if find / -iname Gemini.app 2>/dev/null; then 
	echo "Gemini is installed"
else 
	brew cask install Gemini
fi 

echo "Install Skype"
if find / -iname Skype.app 2>/dev/null; then 
	echo "Skype is installed"
else
	brew cask install skype
fi 

echo "Install Zoom"
curl -L -O https://zoom.us/client/latest/Zoom.pkg
sudo installer -pkg Zoom.pkg -target /

echo "Install Disk Inventory X"
if find / -iname disk-inventory-x.app 2>/dev/null; then 
	echo "Disk Inventory X is installed"
else 
	brew cask install disk-inventory-x
fi 

echo "Install Wireshark"
if find / -iname Wireshark.app 2>/dev/null; then 
	echo "Wireshark is installed" 
else 
	brew cask install wireshark
fi 

echo "Install BatChmod" 
if find / -iname  BatChmod.app 2>/dev/null; then 
	echo "BatChmod is installed"
else 
	brew cask install BatChmod
fi 

echo "Install Github"
if find / -iname github.app 2>/dev/null; then
	echo "Github is installed"
else 
	brew cask installed GitHub
fi

echo "Install IPVanish"
if find / -iname ipvanish*.app 2>/dev/null; then
	echo "IPVanish is installed"
else 
	brew cask install ipvanish-vpn
fi 

echo "Install Hider"
if find / -iname hinder.app 2>/dev/null; then
	echo "Hider is installed"
else 
	brew cask install hider
fi 

echo "Install Opera" 
if find / -iname Opera.app 2>/dev/null; then
	echo "Opera is installed"
else 
	brew cask install Opera
fi

echo "Install CCleaner"
if find / -iname CClearner.app 2>/dev/null; then
	echo "CClearner is installed" 
else 
	brew cask install CCleaner
fi 

echo "Install ZENMAP"
if find / -iname zenmap 2>/dev/null; then
	echo "zenmap is installed"
else 
	brew cask install zenmap 
fi 

echo "Install EvilOSX" 
#git clone https://github.com/Marten4n6/EvilOSX.git 
#cd EvilOSX
#./Server

echo "Install HashCat" 
#git clone https://github.com/hashcat/hashcat.git
#mkdir -p hashcat/deps
#git clone https://github.com/Khronos/OpenCL -Headers.git hashcat/deps/OpenCL
#cd hashcat/
#make
#./hashcat -m2500 -b 
#./hashcat -m2500 file.hccap dictionary 


echo "Install Splunk via command line" 
wget -O splunk-7.1.1-8f0ead9ec3db-macosx-10.11-intel.dmg 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86&platform=macos&version=7.1.1&product=splunk&filename=splunk-7.1.1-8f0ead9ec3db-macosx-10.11-intel.dmg&wget=true'

 
echo "Harden Wifi Settings" 
RequireAdminPowerToggle=YES
RequireAdminNetworkChange=YES
RequireAdminIBSS=YES

echo "Move Mac's Dock to the Corner"
defaults write com.apple.dock pinning -string end 
killall Dock

echo "Show Hidden Files"
defaults write com.apple.finder AppleShowAllFiles false
killall Dock

echo "Itunes Notifications"
defaults write com.apple.dock itunes-notifications -bool TRUE 
killall Dock

echo "Disable SpotLight"
cd /Applications/Utilities
launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

echo "Allow apps downloaded from anywhere"
spctl --master-disable

echo "Enable Debug Mode" 
defaults write com.apple.addressbook ABShowDebugMenu -bool true
defaults write com.apple.iCal IncludeDebugMenu -bool true
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

echo "Disable the Startup Chime"
nvram SystemAudioVolume=%80

echo "Automatically Hide and Show Dock"
defaults write com.apple.Dock autohide-delay -float 0 
killall Dock

echo "Disable Window Animations"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

echo "Remove IR support software"
rm -rf /System/Library/Extensions/AppleIRController.kext

echo "Harden Mac OS"
curl -L -O https://iasecontent.disa.mil/stigs/zip/U_Apple_OS_X_10-13_V1R1_STIG.zip
unzip U_Apple_OS_X_10-13_V1R1_STIG.zip
cd /Users/rd/Downloads/U_Apple_OS_X_10-13_V1R1_STIG/U_Apple_OS_X_10-13_V1R1_Mobile_Configuration_Files
/usr/bin/profiles -I -F U_Apple_OS_X_10-13_V1R0-1_STIG_Bluetooth_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-13_V1R0-1_STIG_Custom_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-13_V1R0-1_STIG_Login_Window_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-13_V1R0-1_STIG_Passcode_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-13_V1R0-1_STIG_Restrictions_Policy.mobileconfig
/usr/bin/profiles -I -F U_Apple_OS_X_10-13_V1R0-1_STIG_Security_and_Privacy_Policy.mobileconfig
/usr/bin/profiles -I -F 2018 U_Apple_OS_X_10-13_V1R0-1_STIG_SmartCard_Policy.mobileconfig

echo "Remove Bluetooth support software" 
rm -rf /System/Library/Extensions/IOBluetoothFamily.kext
rm -rf /System/Library/Extensions/IOBluetoothHIDDriver.kext

echo "Remove audio support software"
rm -rf /System/Library/Extensions/AppleUSBAudio.kext 
rm -rf /System/Library/Extensions/IOAudioFamily.kext

echo "Remove external FaceTime camera"
# srm -rf /System/Library/Extensions/Apple_iSight.kext

echo "Remove internal FaceTime camera" 
# srm -rf /System/Library/Extensions/IOUSBFamily.kext/Contents/PlugIns/AppleUSBVideoSupport.kext

echo "Remove USB support hardware"
rm -rf /System/Library/Extensions/IOUSBMassStorageClass.kext

echo "Use a command-line tool for secure startup"
nvram security-mode=full
nvram -x -p

echo "Change your login window access warning"
defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "'<You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.'"

echo "Enable access warning" 
sudo touch /etc/motd
sudo chmod 644 /etc/motd 
sudo echo "<Warning you are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only. By using this IS (which includes any device attached to this IS), you consent to the following conditions:
-The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
-At any time, the USG may inspect and seize data stored on this IS.
-Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose.
-This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy.
-Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details.>"
 >> /etc/motd

echo "Set all “Number of Recent Items” preferences to None"
defaults write com.apple.recentitems Applications -dict MaxAmount 0

echo "Set idle time for screen saver"
defaults -currentHost write com.apple.screensaver idleTime -int 30

echo "Set host corner to turn on screen saver"
defaults write /Library/Preferences/com.apple.dock.wvous-dtl-corner -int 5

echo "Automatically hide Dock"
defaults write /Library/Preferences/com.apple.dock autohide -bool YES

echo "Display Only Active App in the Mac Dock"
defaults write com.apple.dock static-only -bool TRUE 
killall Dock

echo "Disable dashboard"
defaults write com.apple.dashboard mcx-disabled -boolean YES
killall

echo "Enable Require password to wake this computer from sleep or screen saver"
defaults -currentHost write com.apple.screensaver askForPassword -int 1

echo "Disable Automatic login"
defaults write /Library/Preferences/.GlobalPreferencescom.apple.userspref.DisableAutoLogin -bool yes

echo "Disable automatic login"
defaults write /Library/Preferences/.GlobalPreferencescom.apple.autologout.AutoLogOutDelay -int 0

echo "Enable secure virtual memory"
defaults write /Library/Preferences/com.apple.virtualMemoryUseEncryptedSwap -bool yes

echo "Disable IR remote control"
defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no

echo "Enable FileVault"
/System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount

echo "Enable Firewall"
defaults write /Library/Preferences/com.apple.alf globalstate -int 2

echo "Enable Stealth mode"
defaults write /Library/Preferences/com.apple.alf stealthenabled 1

echo "Enable Firewall Loggin"
defaults write /Library/Preferences/com.apple.alf loggingenabled 1

echo "Disable VoiceOver service"
launchctl unload -w /System/Library/LaunchAgents/com.apple.VoiceOver.plist
launchctl unload -w /System/Library/LaunchAgents/com.apple.ScreenReaderUIServer.plist
launchctl unload -w /System/Library/LaunchAgents/com.apple.scrod.plist

echo "Disable internal microphone or line-in"
 osascript -e "set volume input volume 0"

echo "Disable Sync options"
 defaults -currentHost write com.apple.DotMacSync ShouldSyncWithServer 1

echo "Disable IPv6"
networksetup -setv6off "Wifi"
networksetup -setv6off "Bluetooth"
networksetup -setv6off "Ethernet"
networksetup -setv6off "Firewall"

echo "Turn off Bluetooh"
defaults write /Library/Preferences/com.apple.BluetoothControllerPowerState -int 0

echo "Disable fast user switching"
defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool 'NO'

echo "Set the login options to display name and password in the login window"
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool 'yes'

echo "Disable Time Machine"
defaults write /Library/Preferences/com.apple.TimeMachine AutoBackup 1

echo "Set Password Policy"
tpwpolicy -n /Local/Default -setglobalpolicy "minChars=10 maxFailedLoginAttempts=5"

echo "Disable screen sharing from the command line"
srm /private/etc/ScreenSharing.launchd

echo "Disable SMB"
defaults delete /Library/Preferences/SystemConfiguration/com.apple.smb.server EnabledServices
launchctl unload -w /System/Library/LaunchDaemons/nmbd.plist
launchctl unload -w /System/Library/LaunchDaemons/smbd.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.smb.server.preferences.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.smb.sharepoints.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbfs_load_kext.plist
launchctl unload -w /System/Library/LaunchDaemons/org.samba.winbindd.plist

echo "Disable AFP"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.afpfs_afpLoad.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.afpfs_checkafp.plist

echo "Disable NFS"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.nfsd.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.lockd.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.statd.notify.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.portmap.plist

echo "Disable web sharing"
launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist

echo "Disable Internet sharing"
defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
launchctl unload -w /System/Library/LaunchDaemons/com.apple.InternetSharing.plist

echo "Disable Bluetooth Sharing"
defaults -currentHost write com.apple.bluetooth PrefKeyServicesEnabled 0

echo "Turn off Wi-Fi Services" 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.airportPrefsUpdater.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.AirPort.wps.plist 
launchctl unload -w /System/Library/LaunchAgents/com.apple.airportd.plist

echo "Turn off remote control service using the following command" 
launchctl unload -w /System/Library/LaunchAgents/com.apple.RemoteUI

echo "Turn off screen sharing services"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBEventHelper.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBRegisterMDNS_RemoteManagement.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBRegisterMDNS_ScreenSharing.plist 
launchctl unload -w /System/Library/LaunchAgents/com.apple.ScreenSharing.plist

echo "Turn off Remote Management services"
launchctl unload -w /System/Library/LaunchAgents/com.apple.RemoteDesktop.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RemoteDesktop.PrivilegeProxy.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBEventHelper.plist

echo "Turn off Bluetooth services"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.blued.plist

echo "Enable security auditing"
launchctl load -w /System/Library/LaunchDaemons/com.apple.auditd.plist

echo "Enable mail virus screening"
serveradmin settings mail:postfix:virus_scan_enabled=yes

echo "Disable Text to Speech settings"
defaults write "com.apple.speech.synthesis.general.prefs" TalkingAlertsSpeakTextFlag -bool false 
defaults write "com.apple.speech.synthesis.general.prefs" SpokenNotificationAppActivationFlag -bool false 
defaults write "com.apple.speech.synthesis.general.prefs" SpokenUIUseSpeakingHotKeyFlag -bool false 
defaults delete "com.apple.speech.synthesis.general.prefs" TimeAnnouncementPrefs

echo "Disable Speech Recognition"
defaults write "com.apple.speech.recognition.AppleSpeechRecognition.prefs" StartSpeakableItems -bool false

echo "Enable secure virtual memory"
defaults write /Library/Preferences/com.apple.virtualMemoryUseEncryptedSwap -bool YES

echo "Enable Stealth mode"
defaults write /Library/Preferences/com.apple.alf stealthenabled 1

echo "Enable Firewall Logging"
defaults write /Library/Preferences/com.apple.alf loggingenabled 1

echo "Disable Xgrid Sharing"
launchctl unload -w /System/Library/Daemons/com.apple.xgridagentd
launchctl unload -w /System/Library/Daemons/com.apple.xgridcontrollerd

echo "Disable Remote Apple Events"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.eppc.plist

echo "Disable Remote Management"
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

echo "Harden Google Chrome"
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

echo "Download software updates"
softwareupdate --download --all

echo "Run updates on all installed apps"
softwareupdate -i -a; sudo reboot
