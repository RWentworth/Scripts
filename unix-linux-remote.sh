#! /bin/sh
# set prompt for credentials
echo "Please enter the account name to use on the target server(s):"
read login
echo "Please enter your password on target server(s):"
stty -echo
read pwrd
stty echo

STAMP=`date +%m%d%Y`_`date +%H%M`
GLIST=/media/../list_good
BLIST=/media/../list_bad

# Verify existance of hosts and output to respective lists
for server in $(cat $list)
	do
		if sshpass -p $pwrd shh -o StrickHostKeyChecking=no -l $login $server "uname -a" 2>> /dev/null 1> /dev/null; then # Valid credentials?
			oscheck=`sshpass -p $pwrd ssh -o StrickHostKeyChecking=no $login@$server "/bin/uname -a" | egrep -o "B.11.11|B.11.23|el5|el6|ELsmp|AIX"`
			
			case $oscheck in
		
				B.11.11) # HPUX Version B.11.11
				echo "$server is B.11.11" >> $GLIST # Create a list with successful ssh connections
			;;	
				B.11.23) # HPUX Version B.11.23
				echo "$server is B.11.23" >> $GLIST # Create a list with successful ssh connections
			;;	
				el5) # Red Hat Enterprise Linux 5.x
				echo "$server is RHEL5" >> $GLIST # Create a list with successful ssh connections
			;;
				el6) # Red Hat Enterprise Linux 6.x
				echo "$server is RHEL6" >> $GLIST # Create a list with successful ssh connections
		
				# Set VAR and MKDIR
				UID=`id -u`
				DIR=/media/../unix-linux/$server/"$server"_"$STAMP"
				LOG=/media/../unix-linux/$server/"$server"_"$STAMP"/log.txt
		
				if [ ! -d /media/../unix-linux/"$server" ]; then
				mkdir /media/../unix-linux/"$server"
				fi
	
				mkdir $DIR 2>> /dev/null
				mkdir ~/MOUNT_$server 2>> /dev/null
		
				# Mount ROOT of server via SSHFS
				echo "The OS on $server is: " | tee -a $LOG
				sshpass -p $pwrd ssh -o StrictHostKeyChecking=no $login@$server "uname -a\n" >> $LOG &
				
				# DO WORK
				
			;;	
				ELsmp) # Red Hat Enterprise Linux 4.x
				echo "$server is RHEL4" >> $GLIST # Create a list with successful ssh connections
			;;
				AIX) # AIX
				echo "$server is AIX" >> $GLIST # Create a list with successful ssh connections
			;;
				*)
				
				echo "$server was not found to be AIX, HP-UX B.11.11/23, or RHEL4/5/6." >> $BLIST # Create a list unsuccessful ssh connections
				
			;;	#END null
			
			esac
				else
					echo "$server connection was unsuccessful" >> $BLIST # Create a list unsuccessful ssh connections
				continue
		fi
	done
oscheck=

# RHEL6 checklist
cat /etc/fstab # 8-14, 20-22
cat /boot/grub/grub.conf # 15
cat or ls /sbin/grub-md5-crypt # 16
cat /etc/yum.repos.d/r* or sshpass yum list installed # 17, 63, 65
**Verify BIOS does not allow boot from USB # 18
**ITCCB approved anti-virus w/ latest definitions # 19
(echo /var/tmp: && cat /var/tmp && echo /tmp: && cat /tmp) # 23
ls -la /etc/yum.repos.d/ # 24
rpm -q --queryformat "%{SUMMARY}\n" gpg-pubkey # 25
awk -F: '($2 == "") {print}' /etc/shadow # 26
cat /etc/pam.d/system-auth # 27-34
cat /etc/pam.d/login # 35
egrep "password.*pam_unix.so" /etc/pam.d/system-auth-ac # 36
awk -F: '($2 != "x") {print}' /etc/passwd # 37
cat /etc/login.defs # 38-40
cut -d : -f 2 /etc/group | egrep -v '^(x|!)$' # 40
passwd # 41
(echo /etc/passwd: && cat /etc/passwd && echo && echo trimmed: && cat /etc/passwd | grep /home | cut -d: -f1 && echo && echo /etc/group: && cat /etc/group) # 42, 58
grep "^.*[^\/nologin\$" /etc/passwd # 43
cat /etc/default/useradd # 44
cat /etc/issue # 45
cat /etc/securetty # 46
usermod -L <account> # 47
cat /etc/initab && cat /etc/sysconfig/init # 48, 56
awk -F: ' ($3 == "0") {print}' /etc/passwd # 49
cut -d: -f 1,4 /etc/passwd | egrep ":[1-4] [0-9]{2}$|:[0-9]{1,2}$" && cut -d: -f 1,3 /etc/passwd | egrep ":[1-4] [0-9]{2}$|:[0-9]{1,2}$" # 50-51 
pwck -r # 52
cut -d: -f3 /etc/passwd | uniq -d # 53
**Unique group is created by default with useradd # 54
last root # 55
cat /etc/selinux/init # 57
grep ^wheel /etc/group && cat /etc/pam.d/su # 58
cat /etc/sudoers # 59
env | grep PATH # 60
ls -l <root path> # 61
cat /etc/profile.d/tmouth.sh && cat /etc/profile.d/tmout.csh # 62
crontab -u root -l && ls -l /usr/sbin/aid # 64
cat /etc/hosts.deny && cat /etc/hosts.allow # 66
grep pam_lastlog /etc/pam.d/sshd # 67
cat /etc/ssh/sshd_config # 68-73
chkconfig auditd on # 74
