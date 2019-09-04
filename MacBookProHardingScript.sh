/usr/bin
echo
echo 
echo "########################################################"
echo "Script to harden Mac written by Richard Wentworth 7.4.17"
echo "########################################################"
echo
echo
echo "#####################################################"
echo "################[System Info]#######################"
echo "####################################################"
echo
echo "################[Basic System Info]#################"
system_profiler SPSoftwareDataType
echo 
echo "################[Current Battery Percentage]################"
ioreg -l | awk '$3~/Capacity/{c[$3]=$5}END{OFMT="%.2f%%";max=c["\"MaxCapacity\""];print(max>0?100*c["\"CurrentCapacity\""]/max:"?")}'
echo
echo 
echo "################[Begin Running Scrtip]##################"
p = os.system('echo {}|sudo -S {}'.format('my password', 'command to run'))
echo "########################################################"
echo
echo "###############################################################"
echo "#####################[SOFTWARE  PREREQUISITES]##############"
echo "###############################################################"
echo
echo "################[Allow all applications download]###############"
sudo spctl --master-disable
echo
echo "################[Install Homebrew]################"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo
echo "################[Install WGET]################"
brew install wget
echo
echo "################[Install MAS]################"
brew install mas 
mas upgrade
echo 
echo "###############################################################"
echo "#####################[SOFTWARE  INSTALLS]######################"
echo "###############################################################"
echo 
echo 
echo "################[Install AdGuard]################"
cd ~/Downloads
wget -O AdGuardInstaller.dmg 'https://adguard.com/en/download.html?os=mac&show=1'
sudo cp -R /Volumes/Adguard\ /Applications
sudo hdiutil unmount /Volumes/Adguard
echo
echo "################[Install Antivirus Zap]################"
mas install 1212019923
echo 
echo "################[Install AVGAnti-Virus]################"
brew cask install avg-antivirus
echo 
echo "################[Install AVG Cleaner]################"
mas install 667434228
echo 
echo "################[Install BatChmod]################" 
brew cask install BatChmod
echo
echo "################[Install Bitdefender]################"
mas install 500154009
echo 
echo "################[Install Backup and Sync from Google]################"
#wget -O InstallBackupAndSync.dmg 'https://www.google.com/drive/download/
echo 
echo "################[Install Blue Jeans]################"
wget -O BlueJeansInstaller.dmg 'https://swdl.bluejeans.com/desktop-app/mac/2.15.0/2.15.0.237/BlueJeansInstaller.dmg'
MOUNTDIR=$(echo `hdiutil mount BlueJeansInstaller.dmg | tail -1 \
| awk '{$1=$2=""; print $0}'` | xargs -0 echo) \
&& sudo installer -pkg "${MOUNTDIR}/"*.pkg -target /
echo
echo "################[Install Citrix]################"
wget -O CitrixWorkspaceApp.dmg https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html#ctx-dl-eula
MOUNTDIR=$(echo `hdiutil mount CitrixWorkspaceApp.dmg | tail -1 \
| awk '{$1=$2=""; print $0}'` | xargs -0 echo) \
&& sudo installer -pkg "${MOUNTDIR}/"*.pkg -target /
echo
echo "################[Install CCleaner]################"
sudo wget -O CCMacSetup115.dmg https://download.ccleaner.com/mac/CCMacSetup115.dmg
MOUNTDIR=$(echo `hdiutil mount CCMacSetup115.dmg | tail -1 \
| awk '{$1=$2=""; print $0}'` | xargs -0 echo) \
&& sudo installer -pkg "${MOUNTDIR}/"*.dmg -target /
echo 
echo "################[Install Chrome]################" 
brew cask install google-chrome
echo
#echo "################[Install Chrome RemoteDesktop]################"
#brew install Chrome RemoteDesktop
#echo 
echo "################[Install Clamav]################" 
wget -O clamav-0.100.2.tar.gz 'https://www.clamav.net/downloads/production/clamav-0.100.2.tar.gz'
echo
echo "################[Install CleanMyDrive 2]################" 
mas install 523620159
echo
echo "################[Install CleanMyMac]################" 
sudo wget -O cleanmymacX.dmg https://download.macpaw.com/4.3.1.2/CleanMyMacX.dmg
sudo cp -R /Volumes/CleanMyMac\ X/ /Applications
sudo hdiutil unmount /Volumes/CleanMyMac\ X/
echo
echo "################[Install Cirtrix Reciever]################"
brew install Citrix
echo 
echo "################[Install Discord]################" 
brew cask install Discord
echo
echo "################[Install Disk Inventory X]################"
brew cask install disk-inventory-x
echo
echo "################[Install DiskMap]################"
wget -O "Disk Map (Trial).app" https://download.freedownloadmanager.org/Mac-OS/Disk-Map/FREE-2.4.html?ac58e60
echo
echo "################[Install Duplicate Cleaner For iPhoto]################"
mas install 1024202949
echo 
echo "################[Install Duplicate File Finder]################"
mas install 512883891
echo
echo "################[Install Hacking EvilOSX]################"
#echo "Install EvilOSX" 
#git clone https://github.com/Marten4n6/EvilOSX.git 
#cd EvilOSX
#./Server
echo "################[Install Ghosty Lite]################"
mas install 1406827223
echo
#echo "################[Install Github]################"
#brew cask install GitHub
#echo
echo "################[Install HashCat]################" 
#git clone https://github.com/hashcat/hashcat.git
#mkdir -p hashcat/deps
#git clone https://github.com/Khronos/OpenCL -Headers.git hashcat/deps/OpenCL
#cd hashcat/
#make
#./hashcat -m2500 -b 
#./hashcat -m2500 file.hccap dictionary 
echo
echo "################[Install IPVanish]################"
brew cask install ipvanish-vpn
echo
echo "################[Install Hiddenme]################"
mas install 467040476
echo 
echo "################[Install Hider]################"
mas install 780544053
echo
echo "################[Install Kali Linux]################"
wget -O kali-linux-2019.1a-amd64.iso https://cdimage.kali.org/kali-2019.1a/kali-linux-2019.1a-amd64.iso
echo


wget -O LastPass.dmg "https://lastpass.com/misc_download2.php/safariAppExtension.php?source=download"

echo "################[Install Opera]################" 
brew cask install Opera
echo
echo "################[Install Integrity]################"
mas install 513610341
echo
echo "################[Install iSentry]################"
mas install 479447856
echo 
echo "################[Install MEGAsync]################"
brew cask install MEGAsync
echo
echo "################[Install Memory Clean2]################"
mas install 748212890
echo
echo "################[Install OS Cleaner Master]################"
mas isntall 1084211765
echo
echo "################[Install RingCentral]################"
brew cask install RingCentral
echo 
echo "################[Install RingCentralMeetings]################"
brew cask install ringcentral-meetings
echo 
echo "################[Install SIDT]################"
mas install 1308724728
echo 
echo "################[Install Signal]################"
wget -O signal-desktop-mac-1.26.2.zip "https://updates.signal.org/desktop/signal-desktop-mac-1.26.2.zip" 
MOUNTDIR=$(echo `hdiutil mount signal-desktop-mac-1.26.2.zip | tail -1 \
| awk '{$1=$2=""; print $0}'` | xargs -0 echo) \
&& sudo installer -pkg "${MOUNTDIR}/"*.pkg -target /
echo
echo "################[Install Silent Sifter]################"
mas install 540196459
echo 
echo "################[Install Splunk via command line]################" 
wget -O splunk-7.2.4-8a94541dcfac-macosx-10.11-intel.dmg 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86&platform=macos&version=7.2.4&product=splunk&filename=splunk-7.2.4-8a94541dcfac-macosx-10.11-intel.dmg&wget=true'
sudo hdiutil attach splunk-7.2.4-8a94541dcfac-macosx-10.11-intel.dmg
sudo installer -pkg "/Volumes/Splunk 7.2.4/.payload/Splunk_7.2.4.pkg" -target /
sudo hdiutil unmount "/Volumes/Splunk 7.2.4/.payload/Splunk_7.2.4.pkg" -force
echo 
echo "#################[Install Splunk Universalforwarder]########################"
#Remote to Server 
#(Placeholder for command)
wget -O splunkforwarder-7.2.5-088f49762779-macosx-10.11-intel.dmg 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86&platform=macos&version=7.2.5&product=universalforwarder&filename=splunkforwarder-7.2.5-088f49762779-macosx-10.11-intel.dmg&wget=true'
echo 
echo "################[Install Subline Text]################"
brew cask install sublime-text 
echo
echo "################[Install Skype]################" 
wget -O skype-7-53-0-580.dmg https://dw.uptodown.com/dwn/1MXn6EalVqfbn21fX84dKcThub-Uqszb9YsiAkjyggFPVDrdebJUhwaH9L3HcR8m0XULetwT26j2-us26yeBjwtvxZ-7viOPc9Fl2OoKML1F0gThOwcAQPMVKnMTiuCc/s2KFqRw6WyspQON_dtOjpzbvsay1fQIgwKnMAMEqQLiT842ENtg1z-ekLTDc5z3ERPhGgT89glh_qDRYgkkWGhJ2t3qyYeJk4YO_j4GUdOi65i0EjAWgBNIwvxrXSv2t/aRP1sso_4aKVbp5HcWm_wlDBxky2Kl0YOgqiQsg5unt8oUJ2GfwijeGHuwO3zvnnfYLt5lPl3A_DX2u1aXBqrQ==/
sudo hdiutil attach skype-7-53-0-580.dmg
sudo cp -R "/Volumes/Skype" /Applications
sudo installer -package "/Users/r/Downloads/Skype" -target "/Volumes/Macintosh HD"
sudo hdiutil unmount /Volumes/Skype
echo
echo "################[Install Telegram]################"
brew cask install Telegram
echo
echo "################[Install Termius]################"
mas search 1176074088 
echo
echo "################[Install Tor Browser]################"
brew install tor
mv /usr/local/etc/tor/torrc.sample /usr/local/etc/tor/torrc
echo
echo "################[Install Turn off the Lights Safari]################"
mas install 1273998507
echo
echo "################[Install uTorrent]################"
#sudo wget -O uTorrent.dmg https://www.utorrent.com/downloads/complete/os/osx/track/stable
echo 
echo "################[Install Vivaldi]################"
brew cask install Vivaldi
echo 
echo "################[Install VirtualBox]################"
brew cask install virtualbox
echo
echo "################[Install VLC Player]################"
brew cask install VLC
echo
echo "################[Install VNC]################"
mas install 472995993
echo 
echo "################[Install WhatsApp]################"
brew cask install WhatsApp
echo 
echo "################[Install Wireshark]################"
brew cask install wireshark
echo 
echo "################[Install Zenmap]################"
brew cask install Zenmap 
echo 
echo "################[Install Zoom]################"
wget -O  Zoom.pkg 'https://zoom.us/download'
echo

echo "###############################################################"
echo "#####################[SOFTWARE  REMOVAL]######################"
echo "###############################################################"
echo 
echo 
echo "################[Uninstall Java]################"
sudo rm -fr /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
sudo rm -fr /Library/PreferencePanes/JavaControlPanel.prefpane
echo
echo "################[Uninstall Flash]################" 
udo rm -fr /Library/Preferences/Macromedia/Flash\ Player
udo rm -fr /Library/Caches/Adobe/Flash\ Player
echo
echo "################[softwareupdate]################" 
sudo softwareupdate -iva
echo
echo "#########################################################################"
echo "############################## WIFI #####################################"
echo "#########################################################################"
echo
#echo "Turn on Wifi"
#echo networksetup -setairportpower en0 on
echo
#echo "Connect to Wifi"
#echo networksetup -setairportnetwork en0 "Wifi Name " Password 
echo
echo "#########################################################################"
echo "##################### Bluetooth Settings ################################"
echo "#########################################################################"
echo
echo "################[Ensure Bluetooth is off]################" 
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
sudo killall -HUP blued
echo
echo "################[Show Bluetooth Status in Menu Bar]################" 
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
echo
echo "################[Disable Bluetooth Sharing]################" 
echo "Verify values are Disable"
system_profiler SPBluetoothDataType | grep State
defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 0
echo
echo "################[Remove Bluetooth support software]################" 
#sudo rm -rf /System/Library/Extensions/IOBluetoothFamily.kext
#sudo rm -rf /System/Library/Extensions/IOBluetoothHIDDriver.kext
echo
echo "################[Turn off Bluetooh]################"
defaults write /Library/Preferences/com.apple.BluetoothControllerPowerState -int 0
echo
echo "################[Turn off Bluetooth services]################"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.blued.plist
echo
echo
echo "#########################################################################"
echo "##################### Date & Time #######################################"
echo "#########################################################################"
echo
echo "################[Ensure Network Time is On]################"
sudo systemsetup -getusingnetworktime
echo
echo "################[Set Time Server]################"
sudo ntpdate -sv time.apple.server
echo
echo "################[Set Screen Saver Time]################"
defaults -currentHost write com.apple.screensaver idleTime -int 1200
echo
echo "#########################################################################"
echo "##################### Security & Privacy ###############################"
echo "#########################################################################"
echo
echo "################[Enable FileVault]################"
echo "Ensure FileVault is turned on"
fdesetup status
echo "Enable"
sudo fdesetup enable
#echo "Disable"
#sudo fdesetup disable
echo
echo "################[Enable Gatekeeper]################"
sudo spctl --master-enable
echo
echo "################[Enable Firewall]################"
defaults write /Library/Preferences/com.apple.alf globalstate -int 2
echo
echo "################[Enable Firewall Stealth Mode]################"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
echo
echo "################[Enable Stealth mode]################"
defaults write /Library/Preferences/com.apple.alf stealthenabled 1
echo
echo "################[Enable Location Services]################"
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist
echo
echo "################[Harden Wifi Settings]################" 
RequireAdminPowerToggle=YES
RequireAdminNetworkChange=YES
RequireAdminIBSS=YES
echo
echo "################[Add Spacers To The MacOS Dock]################"
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
killall Dock
echo
echo "################[Move Mac's Dock to the Corner]################"
defaults write com.apple.dock pinning -string end 
killall Dock
echo
echo "################[Show Hidden Files]################"
defaults write com.apple.finder AppleShowAllFiles false
killall Dock
echo
echo "################[Itunes Notifications]################"
defaults write com.apple.dock itunes-notifications -bool TRUE 
killall Dock
echo
echo "################[Disable SpotLight]################"
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist.
echo
echo "################[Allow apps downloaded from anywhere]################"
spctl --master-disable
echo
echo "################[Enable Debug Mode]################" 
defaults write com.apple.addressbook ABShowDebugMenu -bool true
defaults write com.apple.iCal IncludeDebugMenu -bool true
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true
echo
echo "################[Disable the Startup Chime]################"
nvram SystemAudioVolume=%80
echo
echo "################[Automatically Hide and Show Dock]################"
defaults write com.apple.Dock autohide-delay -float 0 
killall Dock
echo
echo "################[Disable Window Animations]################"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
echo
echo "################[Remove IR support software]################"
rm -rf /System/Library/Extensions/AppleIRController.kext
echo
echo "################[Harden Mac OS]################"
curl -L -O https://iasecontent.disa.mil/stigs/zip/U_Apple_OS_X_10-12_V1R4_STIG.zip
unzip U_Apple_OS_X_10-12_V1R4_STIG.zip 
cd /Users/rw/Downloads/U_Apple_OS_X_10-12_V1R4_Mobile_Configuation_Files
/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R4_STIG_Application_Restrictions_Policy.mobileconfig
#/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Custom_Policy.mobileconfig
#/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Login_Window_Policy.mobileconfig
#/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Restrictions_Policy.mobileconfig
#/usr/bin/profiles -I -F U_Apple_OS_X_10-11_V1R5_STIG_Security_and_Privacy_Policy.mobileconfig
echo
echo
echo "################[Remove audio support software]################"
rm -rf /System/Library/Extensions/AppleUSBAudio.kext 
rm -rf /System/Library/Extensions/IOAudioFamily.kext
echo 
echo "################[Remove external FaceTime camera]################"
# srm -rf /System/Library/Extensions/Apple_iSight.kext
echo 
echo "################[Remove internal FaceTime camera]################" 
# srm -rf /System/Library/Extensions/IOUSBFamily.kext/Contents/PlugIns/AppleUSBVideoSupport.kext
echo 
echo "################[Remove USB support hardware]################"
rm -rf /System/Library/Extensions/IOUSBMassStorageClass.kext
echo 
echo "################[Use a command-line tool for secure startup]################"
nvram security-mode=full
nvram -x -p
echo 
echo "################[Change your login window access warning]################"
defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "'You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.'"
echo 
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
echo 
echo "################[Set all “Number of Recent Items” preferences to None]################"
defaults write com.apple.recentitems Applications -dict MaxAmount 0
echo 
echo "################[Set idle time for screen saver]################"
defaults -currentHost write com.apple.screensaver idleTime -int 30
echo 
echo "################[Set host corner to turn on screen saver]################"
defaults write /Library/Preferences/com.apple.dock.wvous-dtl-corner -int 5
echo 
echo "################[Automatically hide Dock]################"
defaults write /Library/Preferences/com.apple.dock autohide -bool YES
echo 
echo "################[Display Only Active App in the Mac Dock]################"
defaults write com.apple.dock static-only -bool TRUE 
killall Dock
echo 
echo "################[Disable dashboard]################"
defaults write com.apple.dashboard mcx-disabled -boolean YES
killall
echo 
echo "################[Enable Require password to wake this computer from sleep or screen saver]################"
defaults -currentHost write com.apple.screensaver askForPassword -int 1
echo 
echo "################[Disable Automatic login]################"
defaults write /Library/Preferences/.GlobalPreferencescom.apple.userspref.DisableAutoLogin -bool yes
echo	
echo "################[Disable automatic login]################"
defaults write /Library/Preferences/.GlobalPreferencescom.apple.autologout.AutoLogOutDelay -int 0
echo
echo "################[Enable secure virtual memory]################"
defaults write /Library/Preferences/com.apple.virtualMemoryUseEncryptedSwap -bool yes
echo
echo "################[Disable IR remote control]################"
defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no
echo
echo "################[Enable Firewall Loggin]################"
defaults write /Library/Preferences/com.apple.alf loggingenabled 1
echo
echo "################[Disable VoiceOver service]################"
launchctl unload -w /System/Library/LaunchAgents/com.apple.VoiceOver.plist
launchctl unload -w /System/Library/LaunchAgents/com.apple.ScreenReaderUIServer.plist
launchctl unload -w /System/Library/LaunchAgents/com.apple.scrod.plist
echo
echo "################[Disable internal microphone or line-in]################"
osascript -e "set volume input volume 0"
echo
echo "################[Disable Sync options]################"
defaults -currentHost write com.apple.DotMacSync ShouldSyncWithServer 1
echo
echo "################[Disable IPv6]################"
networksetup -setv6off "Wifi"
networksetup -setv6off "Bluetooth"
networksetup -setv6off "Ethernet"
networksetup -setv6off "Firewall"
echop
echo "################[Disable fast user switching]################"
defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool 'NO'
echo
echo "################[Set the login options to display name and password in the login window]################"
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool 'yes'
echo
echo "################[Disable Time Machine]################"
defaults write /Library/Preferences/com.apple.TimeMachine AutoBackup 1
echo
echo "################[Set Password Policy]################"
tpwpolicy -n /Local/Default -setglobalpolicy "minChars=10 maxFailedLoginAttempts=5"
echo
echo "################[Disable SMB]################"
defaults delete /Library/Preferences/SystemConfiguration/com.apple.smb.server EnabledServices
launchctl unload -w /System/Library/LaunchDaemons/nmbd.plist
launchctl unload -w /System/Library/LaunchDaemons/smbd.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.smb.server.preferences.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.smb.sharepoints.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbfs_load_kext.plist
launchctl unload -w /System/Library/LaunchDaemons/org.samba.winbindd.plist
echo
echo "################[Disable AFP]################"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.afpfs_afpLoad.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.afpfs_checkafp.plist
echo
echo "[################[Disable NFS]################"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.nfsd.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.lockd.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.statd.notify.plist
launchctl unload -w /System/Library/LaunchDaemons/com.apple.portmap.plist
echo
echo "################[Disable web sharing]################"
launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
echo
echo "################[Disable Internet sharing]################"
defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
launchctl unload -w /System/Library/LaunchDaemons/com.apple.InternetSharing.plist
echo
echo "################[Turn off Wi-Fi Services]################" 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.airportPrefsUpdater.plist 
launchctl unload -w /System/Library/LaunchDaemons/com.apple.AirPort.wps.plist 
launchctl unload -w /System/Library/LaunchAgents/com.apple.airportd.plist
echo
echo "################[Turn off remote control service using the following command]################" 
launchctl unload -w /System/Library/LaunchAgents/com.apple.RemoteUI
echo
echo "################[Turn off screen sharing services]################"
#launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBEventHelper.plist 
#launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBRegisterMDNS_RemoteManagement.plist 
#launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBRegisterMDNS_ScreenSharing.plist 
#launchctl unload -w /System/Library/LaunchAgents/com.apple.ScreenSharing.plist
echo
echo "################[Turn off Remote Management service]################"
#launchctl unload -w /System/Library/LaunchAgents/com.apple.RemoteDesktop.plist 
#launchctl unload -w /System/Library/LaunchDaemons/com.apple.RemoteDesktop.PrivilegeProxy.plist 
#launchctl unload -w /System/Library/LaunchDaemons/com.apple.RFBEventHelper.plist
echo
echo "################[Enable security auditing]################"
launchctl load -w /System/Library/LaunchDaemons/com.apple.auditd.plist
echo
echo "################[Enable mail virus screening]################"
serveradmin settings mail:postfix:virus_scan_enabled=yes
echo
echo "################[Disable Text to Speech settings]################"
defaults write "com.apple.speech.synthesis.general.prefs" TalkingAlertsSpeakTextFlag -bool false 
defaults write "com.apple.speech.synthesis.general.prefs" SpokenNotificationAppActivationFlag -bool false 
defaults write "com.apple.speech.synthesis.general.prefs" SpokenUIUseSpeakingHotKeyFlag -bool false 
defaults delete "com.apple.speech.synthesis.general.prefs" TimeAnnouncementPrefs
echo
echo "################[Disable Speech Recognition]################"
defaults write "com.apple.speech.recognition.AppleSpeechRecognition.prefs" StartSpeakableItems -bool false
echo
echo "################[Enable secure virtual memory]################"
defaults write /Library/Preferences/com.apple.virtualMemoryUseEncryptedSwap -bool YES
echo
echo "################[Enable Stealth mode]################"
defaults write /Library/Preferences/com.apple.alf stealthenabled 1
echo
echo "################[Enable Firewall Logging]################"
defaults write /Library/Preferences/com.apple.alf loggingenabled 1
echo
echo "################[Disable Xgrid Sharing]################"
launchctl unload -w /System/Library/Daemons/com.apple.xgridagentd
launchctl unload -w /System/Library/Daemons/com.apple.xgridcontrollerd
echo
echo "################[Disable Remote Apple Events]################"
launchctl unload -w /System/Library/LaunchDaemons/com.apple.eppc.plist
echo
echo "################[Disable Remote Management]################"
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop
echo
echo
echo "#########################################################################"
echo "##################### Application Hardening ##############################"
echo "#########################################################################"
echo
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
echo
echo "#########################################################################"
echo "##################### System Configurations ###############################"
echo "#########################################################################"
echo
echo "################[Disable Remote Apple Events]##########################"
sudo systemsetup -setremoteappleevents off
echo
echo "################[Disable Internet Sharing]#############################"
echo "The file should not exist or Enabled = 0 for all network interfaces"
sudo defaults read /Library/Preferences/SystemConfiguration/com.apple.nat | grep -i Enabled
echo
echo "################[Disable Screen Sharing]#############################"
echo "Verify the value returned is Service is disabled"
# Enable Only Screen Sharing
#sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
echo
echo "################[Disable Printer Sharing]#############################"
lpadmin -p Printer_Name -o printer-is-shared=false
echo
echo "################[Disable Remote Login]#############################"
#sudo systemsetup -setremotelogin off
echo
echo "################[Hide SpotLight]################"
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
killall SystemUIServer
echo
echo "################[Disable DVD or CD Sharing]################"
echo "If com.apple.ODSAgent" appears in the result the control is not in place. No result is compliant.""
sudo launchctl list | egrep ODSAgent 
rm -f /Library/Preferences/SystemConfiguration/com.apple.ODSAgent
echo
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
echo 
echo "#########################################################################"
echo "##################### PATCHES & UPDATES #################################"
echo "#########################################################################"
echo
echo "################[Download software updates]################"
softwareupdate --download --all
echo
echo "################[Enable Check for Auto Updates]################"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -int 1
echo
echo "################[Enable AutoUpdate]################"
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE
echo
echo "################[Auto update patches]################"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true && sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
echo
echo"#################[Enable Install Updates]################"
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool TRUE
echo
echo "################[Enable AutoUpdate]#####################"
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE
echo
echo "################[Auto update patches]#####################"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true && sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
echo
echo "################[Last Full Successful Date]#####################"
defaults read /Library/Preferences/com.apple.SoftwareUpdate | egrep LastFullSuccessfulDate
echo
echo
echo "#########################################################################"
echo "############################ Reboot #####################################"
echo "#########################################################################"
echo
echo "#####################[Reboot]#####################"
sudo reboot
