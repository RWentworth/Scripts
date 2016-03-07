#!/bin/bash
STAMP=`date +%m%d%Y`_`date +%H%M`
server=$(hostname)
output=/tmp/RESULTS/"$server"_"$STAMP".txt 

echo -e "Executing Red Hat Enterprise Linux 6 Security Configuration Standard 1.0 8/5/2013 on $STAMP by $(whoami)\n"

(if [[ ! -d /tmp/RESULTS ]]; then
	mkdir -p /tmp/RESULTS 
	echo -e "Creating /tmp/RESULTS directory\n"
else
	echo -e "The /tmp/RESULTS directory exists\n" 
fi) 

sudo chmod -R 777 /tmp/RESULTS 

echo "1,,,,Y, This requirement is assumed." >> $output  2>/tmp/RESULTS/errors.txt	
echo "2,,,,Y, This requirement is based on other deparement requirments." >> $output  2>/tmp/RESULTS/errors.txt
echo "3,,,,Y, This requirement is based on other deparement requirments." >> $output  2>/tmp/RESULTS/errors.txt

#4
(if [[ $(grep -o "en_US.UTF-8" /etc/sysconfig/language) = "en_US.UTF-8" ]]; then 
	echo "4,,,,Y"
else
	[[ -e /etc/sysconfig/language ]] && echo "4,,,,N, File exists" || echo "4,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

echo "5,,,,Y", $(hostname) >> $output  2>/tmp/RESULTS/errors.txt

#6
(if [[ $(egrep -o "minlen=12" /etc/pam.d/system-auth) = "minlen=12" || $(egrep -o "minlen=14" /etc/pam.d/system-auth) = "minlen=14" ]] && [[ $(egrep -o "dcredit=-1" /etc/pam.d/system-auth) = "dcredit=-1" ]] && [[ $(egrep -o "ucredit=-1" /etc/pam.d/system-auth) = "ucredit=-1" ]] && [[ $(egrep -o "ocredit=-1" /etc/pam.d/system-auth) = "ocredit=-1" ]] && [[ $(egrep -o "lcredit=-1" /etc/pam.d/system-auth) = "lcredit=-1" ]] && [[ $(egrep -o "difok=4" /etc/pam.d/system-auth) = "difok=4" ]]; then 
	echo "6,,,,Y"
else
	[[ -e /etc/pam.d/system-auth ]] && echo "6,,,,N, File exists" || echo "6,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

echo "7,,,,Y, This requirement can is dependent upon user actions" >> $output  2>/tmp/RESULTS/errors.txt

#8
(if [[ $(egrep -o root /etc/fstab) = "root" ]]; then 
	echo "8,,,,Y"
else
	echo "8,,,,N, These requirements can only be performed at initial server build. This cannot be performed after."
fi) >> $output  2>/tmp/RESULTS/errors.txt

#9
(if [[ $(egrep -o boot /etc/fstab) = "boot" ]]; then
	echo "9,,,,Y"
else
	echo "9,,,,N, These requirements can only be performed at initial server build. This cannot be performed after."
fi)  >> $output  2>/tmp/RESULTS/errors.txt

#10
(if [[ $(egrep -o home /etc/fstab) = "home" ]]; then
	echo "10,,,,Y"
else
	echo "10,,,,N, These requirements can only be performed at initial server build. This cannot be performed after."
fi) >> $output  2>/tmp/RESULTS/errors.txt  
  
#11
(if [[ $(egrep -o tmp /etc/fstab) = "tmp" ]]; then
	echo "11,,,,Y"
else
	echo "11,,,,N, These requirements can only be performed at initial server build. This cannot be performed after."
fi) >> $output  2>/tmp/RESULTS/errors.txt  
    
#12
(if [[ $(egrep -o var /etc/fstab) = "var" ]]; then
	echo "12,,,,Y"
else
	echo "12,,,,N, These requirements can only be performed at initial server build. This cannot be performed after."
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#13
(if [[ $(egrep -o log /etc/fstab) = "/var/log" ]]; then
	echo "13,,,,Y"
else
	echo "13,,,,N, These requirements can only be performed at initial server build. This cannot be performed after."
fi) >> $output  2>/tmp/RESULTS/errors.txt  
  
#14
(if [[ $(egrep -o audit /etc/fstab) = /var/log/audit ]]; then
	echo "14,,,,Y"
else
	echo "14,,,,N, These requirements can only be performed at initial server build. This cannot be performed after."
fi) >> $output  2>/tmp/RESULTS/errors.txt  
  
#15
(if [[ $(ls -d /boot/grub/grub.conf) = "/boot/grub/grub.conf" ]]; then
	echo "15,,,,Y" 
else
	[[ -e /boot/grub/grub.conf ]] && echo "15,,,,N, File exists" || echo "15,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#16
(if [[ $(egrep -o password /boot/grub/grub.conf) = "password" ]]; then
	echo "16,,,,Y"
else
    [[ -e /boot/grub/grub.conf ]] && echo "16,,,,N, File exists" || echo "16,,,,N, File does not exists" 
fi) >> $output 2>/tmp/RESULTS/errors.txt

#17
(if [[ $(rpm -qa | wc -l) -ge 1 ]]; then
	echo "17,,,,Y"
else
	echo "17,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#18
(if [[ $(egrep -o "stage2=/boot/grub/stage2" /etc/grub.conf) = "stage2=/boot/grub/stage2" ]]; then
	echo "18,,,,Y"
else 	
	[[ -e /etc/grub.conf ]] && echo "18,,,,N, File exists" || echo "18,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt

#19
(if [[ $(rpm -q symantec) = "package symantec is installed" ]]; then
	echo "19,,,,Y"
else
	echo "19,,,,N, Symantec is not installed "
fi) >> $output  2>/tmp/RESULTS/errors.txt

#20
(if [[ $(grep -n "ext" /etc/fstab | head -n 1 | awk '{print $3}') = ext2 ]]; then
	echo "20,,,,Y"
elif 
[[ $(grep -n "ext" /etc/fstab | head -n 1 | awk '{print $3}') = ext3 ]]; then
	echo "20,,,,Y"
elif 
[[ $(grep -n "ext" /etc/fstab | head -n 1 | awk '{print $3}') = ext4 ]]; then
	echo "20,,,,Y"
else 
	[[ -e /etc/fstab ]] && echo "20,,,,N, File exists" || echo "20,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt

#21
(if [[ $(egrep -o floppy /etc/fstab) = "floppy" ]] && 
[[ $(egrep -o cdrom /etc/fstab) = "cdrom" ]]; then
	echo "21,,,,Y"
else
	[[ -e /etc/fstab ]] && echo "21,,,,N, File exists" || echo "21,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#22
(if [[ $(egrep -o tmp /etc/fstab) = "/tmp" ]] && 
[[ $(egrep -o shm /etc/fstab) = "/dev/shm" ]]; then
	echo "22,,,,Y"
else
	[[ -e /etc/fstab ]] && echo "22,,,,N, File exists" || echo "22,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#23
(if [[ $(egrep -o "/tmp" /etc/fstab | head -n 1) = "/tmp" ]] &&
[[ $(egrep -o "/var/tmp" /etc/fstab | head -n 1) = "/var/tmp" ]] &&
[[ $(egrep -o "none" /etc/fstab | head -n 1) = "none" ]] &&
[[ $(egrep -o "rw" /etc/fstab | head -n 1) = "rw" ]] &&
[[ $(egrep -o "noexec" /etc/fstab | head -n 1) = "noexec" ]] &&
[[ $(egrep -o "nosuid" /etc/fstab | head -n 1) = "nosuid" ]] &&
[[ $(egrep -o "nodev" /etc/fstab | head -n 1) = "nodev" ]] &&
[[ $(egrep -o "bind" /etc/fstab | head -n 1) = "bind" ]] &&
[[ $(egrep -o "0 0" /etc/fstab | head -n 1) = "0 0" ]]; then
	echo "23,,,,Y"
else
	[[ -e /etc/fstab ]] && echo "23,,,,N, File exists" || echo "23,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#24
(if [[ $(ls -l /etc/yum.repos.d | wc -l) -gt 1 ]]; then
	echo "24,,,,Y" 
else 
	[[ -e /etc/pam.d/yum.repos.d ]] && echo "24,,,,N, File exists" || echo "24,,,,N, File does not exists"  
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#25 
(if [[ $(rpm -qa gpg-pubkey* | wc -l) -gt 1 ]]; then 
	echo "25,,,,Y"
else 
	echo "25,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#26
(if [[ $(egrep -o nullok /etc/pam.d/system-auth) = nullok ]]; then
	echo "26,,,,Y"
else
	[[ -e /etc/pam.d/system-auth ]] && echo "26,,,,N, File exists" || echo "26,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#27 
(if [[ $(egrep -o minlen=12 /etc/pam.d/system-auth) = minlen=12 ]]; then
	echo "27,,,,Y"
elif [[ $(egrep -o minlen=14 /etc/pam.d/system-auth) = minlen=14 ]]; then
	echo "27,,,,Y"
else		
	[[ -e /etc/pam.d/system-auth ]] && echo "27,,,,N, File exists" || echo "27,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#28 
(if [[ $(egrep -o ucredit=-1 /etc/pam.d/system-auth) = ucredit=-1 ]]; then
	echo "28,,,,Y"
else 		
	[[ -e /etc/pam.d/system-auth ]] && echo "28,,,,N, File exists" || echo "28,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   	

#29 
(if [[ $(egrep -o lcredit=-1 /etc/pam.d/system-auth) = lcredit=-1 ]]; then
	echo "29,,,,Y"
else 		
	[[ -e /etc/pam.d/system-auth ]] && echo "29,,,,N, File exists" || echo "29,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#30
(if [[ $(egrep -o dcredit=-1 /etc/pam.d/system-auth) = dcredit=-1 ]]; then
	echo "30,,,,Y"
else 		
	[[ -e /etc/pam.d/system-auth ]] && echo "30,,,,N, File exists" || echo "30,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt

#31
(if [[ $(egrep -o ocredit=-1 /etc/pam.d/system-auth) = ocredit=-1 ]]; then
	echo "31,,,,Y"
else 		
	[[ -e /etc/pam.d/system-auth ]] && echo "31,,,,N, File exists" || echo "31,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#32
(if [[ $(egrep -o difok=4 /etc/pam.d/system-auth) = difok=4 ]]; then
	echo "32,,,,Y"
else 		
	[[ -e /etc/pam.d/system-auth ]] && echo "32,,,,N, File exists" || echo "32,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#33
(if [[ $(egrep -o maxrepeat=3 /etc/pam.d/system-auth) = maxrepeat=3 ]]; then
	echo "33,,,,Y"
else 		
	[[ -e /etc/pam.d/system-auth ]] && echo "33,,,,N, File exists" || echo "33,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#34
(if [[ $(egrep -o remember=24 /etc/pam.d/system-auth) = remember=24 ]]; then
	echo "34,,,,Y"
else 		
	[[ -e /etc/pam.d/system-auth ]] && echo "34,,,,N, File exists" || echo "34,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#35
(if [[ $(egrep -e "unlock_time=1200" /etc/pam.d/login) = "auth required pam_tally2.so deny=5 even_deny_root unlock_time=1200" ]]; then
	echo "35,,,,Y"
else 		
	[[ -e /etc/pam.d/login ]] && echo "35,,,,N, File exists" || echo "35,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#36
(if [[ $(egrep -o sha512 /etc/pam.d/system-auth-ac) = sha512 ]]; then
	echo "36,,,,Y"
else 
	[[ -e /etc/pam.d/system-auth-ac ]] && echo "36,,,,N, File exists" || echo "36,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#37
(if [[ $(awk -F: '($2 != "x") {print}' /etc/passwd ) != "#" ]]; then
	echo "37,,,,Y"
else
	[[ -e /etc/passwd ]] && echo "37,,,,N, File exists" || echo "37,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#38
(if [[ $(egrep PASS_MAX_DAYS /etc/login.defs | cut -f2 | grep '[0-9]') = 60 ]]; then 
	echo "38,,,,Y"
else
	[[ -e /etc/login.defs ]] && echo "38,,,,N, File exists" || echo "38,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#39 
(if [[ $(egrep PASS_MIN_DAYS /etc/login.defs | cut -f2 | grep '[0-9]') = 1 ]]; then 
	echo "39,,,,Y"
else 
	[[ -e /etc/login.defs ]] && echo "39,,,,N, File exists" || echo "39,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#40
(if [[ $(cut -d : -f 2 /etc/group | egrep -v '^(x|!)$' | wc -l ) -eq 0 ]]; then
	echo "40,,,,Y"
else
	[[ -e /etc/group ]] && echo "40,,,,N, File exists" || echo "40,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

echo "41,,,,Y, Standard is change root password upon compromise or employee exit" >> $output  2>/tmp/RESULTS/errors.txt

#42 
(if [[ $(sudo cat /etc/passwd | wc -l) -gt 1 ]]; then 
	echo "42,,,,Y"
else	
	[[ -e /etc/passwd ]] && echo "42,,,,N, File exists" || echo "42,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#43 
(if [[ $(grep "^.*[^\/nologin]$" /etc/passwd | wc -l) -gt 1 ]]; then
	echo "43,,,,Y"
else 
	[[ -e /etc/passwd ]] && echo "43,,,,N, File exists" || echo "43,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#44
(if [[ $(egrep -o INACTIVE=35 /etc/default/useradd) = "INACTIVE=35" ]]; then
	echo "44,,,,Y"
else
	[[ -e /etc/default/useradd ]] && echo "44,,,,N, File exists" || echo "44,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#45
(if [[ $(egrep -o "You are accessing a U.S. Government information system, which includes" /etc/issue) = "You are accessing a U.S. Government information system, which includes" ]]; then
	echo "45,,,,Y"
else 
	[[ -e /etc/issue ]] && echo "45,,,,N, File exists" || echo "45,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#46
(if [[ $(egrep console /etc/securetty) = "console" && $(egrep tty1 /etc/securetty)  = "tty1" ]]; then
	echo "46,,,,Y"
 else
	[[ -e /etc/securetty ]] && echo "46,,,,N, File exists" || echo "46,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt   

echo "47,,,,Y, This requirement is dependent upon review of item 42" >> $output  2>/tmp/RESULTS/errors.txt

#48
(if [[ $(egrep -o ":S:wait:/sbin/sulogin" /etc/inittab) = "S:wait:/sbin/sulogin" ]]; then
	echo "48,,,,Y"
else 
	[[ -e /etc/inittab ]] && echo "48,,,,N, File exists" || echo "48,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#49
(if [[ $(awk -F: ' ($3 == "0") {print}' /etc/passwd) = "root:x:0:0:root:/root:/bin/bash" ]]; then
	echo "49,,,,Y"
else 
	[[ -e /etc/passwd ]] && echo "49,,,,N, File exists" || echo "49,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#50
(if [[ $(cut -d: -f 1,4 /etc/passwd | egrep ":[1-4][0-9]{2}$|:[0-9]{1,2}$" | wc -l) -ge 1  ]]; then 
	echo "50,,,,Y"
else 
	[[ -e /etc/passwd ]] && echo "50,,,,N, File exists" || echo "50,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#51
(if [[ $(cut -d: -f 1,3 /etc/passwd | egrep ":[1-4][0-9]{2}$|:[0-9]{1,2}$" | wc -l) -ge 1 ]]; then
	echo "51,,,,Y"
else
	[[ -e /etc/passwd ]] && echo "51,,,,N, File exists" || echo "51,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#52
(if [[ $(sudo pwck -r | uniq | wc -l) -ge 1 ]]; then 
	echo "52,,,,Y"
else 
	echo "52,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#53
(if [[ $(cut -d: -f3 /etc/passwd | uniq | wc -l) -ge 1 ]]; then
	echo "53,,,,Y"
else
	[[ -e /etc/passwd ]] && echo "53,,,,N, File exists" || echo "53,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

echo "54,,,,Y" >> $output  2>/tmp/RESULTS/errors.txt

echo "55,,,,Y" >> $output  2>/tmp/RESULTS/errors.txt

#56
(if [[ $(egrep -o PROMPT /etc/sysconfig/init) = "PROMPT=no" ]]; then
	echo "56,,,,Y"
else
	[[ -e /etc/sysconfig/init ]] && echo "56,,,,N, File exists" || echo "56,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#57
(if [[ $(egrep -e SELINUX /etc/sysconfig/config) = "SELINUX=enforcing" ]] && 
[[ $(egrep -e SELINUXTYPE /etc/sysconfig/config) = "SELINUXTYPE=targeted" ]]; then 
	echo "57,,,,Y"
else 
	[[ -e /etc/sysconfig/config ]] && echo "57,,,,N, File exists" || echo "57,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#58
(if [[ $(grep ^wheel /etc/group) = "wheel:x:10:admin" ]] && 
[[ $(grep pam_wheel.so /etc/pam.d/su) = "pam_wheel.so" ]]; then
	echo "58,,,,Y"
else
	echo "58,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#59 
(if [[ $(cat /etc/sudoers | wc -l) -ge 1 ]]; then
	echo "59,,,,Y"
else 
	[[ -e /etc/sudoers ]] && echo "59,,,,N, File exists" || echo "59,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#60
(if [[ $(env | grep PATH) = "null" ]]; then
	echo "60,,,,N"
else
	echo "60,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#61
(if [[ $(ls -l / | grep "^.\{2\}[r]") = "r" ]] && 
[[$(ls -l / | grep "^.\{3\}[w]") ]]; then
	echo "61,,,,N"
else
	echo "61,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt 
 
#62 
(if [[ $(egrep -o "TMOUT=900" /etc/profile.d/tmout.sh) = "TMOUT=900" ]] && 
[[ $(egrep -o "readonly TMOUT" /etc/profile.d/tmout.sh) = "readonly TMOUT" ]] && 
[[ $(egrep -o "export TMOUT" /etc/profile.d/tmout.sh) = "export TMOUT" ]] && 
[[ $(egrep -o "autologout=15" /etc/profile.d/tmout.csh) = "autologout=15" ]] &&
[[ $(stat --format '%a' /etc/profile.d/tmout.sh) -eq 644 ]] &&
[[ $(stat --format '%a' /etc/profile.d/tmout.csh) -eq 644 ]]; then
	echo "62,,,,Y" 
else 
	[[ -e /etc/profile.d/tmout.sh ]] && echo "62,,,,N, File exists" || echo "62,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#63
(if [[ $(rpm -qa | grep *aide*) = "*aide*" ]]; then
	echo "63,,,,Y"
else
	echo "63,,,,N, AIDE is not a default base package"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#64
(if [[ $(crontab -u root -l) = "no crontab for root" ]]; then
	echo "64,,,,N, no contrab for root"
else 
	echo "64,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#65 
(if [[ $(rpm -qa | grep *tcp_wrapper*) = "*tcp_wrapper*" ]]; then 
	echo "65,,,,Y"
else 
	echo "65,,,,N, TCP_WRAPPERS package not installed"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#66
(if [[ $(egrep ALL /etc/hosts.deny) = "ALL: ALL" ]] && 
[[ $(cat /etc/hosts.allow | wc -l) -ge 0 ]]; then
	echo "66,,,,Y"
else
	[[ -e /etc/hosts.deny ]] && echo "66,,,,N, File exists" || echo "66,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#67
(if [[ $(egrep -o pam_lastlog /etc/pam.d/sshd) = "pam_lastlog" ]]; then
	echo "67,,,,Y"
else       
	[[ -e /etc/pam.d/sshd ]] && echo "67,,,,N, File exists" || echo "67,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

echo "68,,,,Y"  >> $output  2>/tmp/RESULTS/errors.txt

#69
(if [[ $(egrep -o "Protocol 2" /etc/ssh/sshd_config) = "Protocol 2" ]]; then
	echo "69,,,,Y"
else
	[[ -e /etc/ssh/sshd_config ]] && echo "69,,,,N, File exists" || echo "69,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#70
(if [[ $(egrep -o "aes128-ctr,aes192-ctr,aes256-ctr" /etc/ssh/sshd_config) = "aes128-ctr,aes192-ctr,aes256-ctr" ]]; then
	echo "70,,,,Y"
else
	[[ -e /etc/ssh/sshd_config ]] && echo "70,,,,N, File exists" || echo "70,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#71
(if [[ $(egrep -e "PermitRootLogin no" /etc/ssh/sshd_config) = "PermitRootLogin no" ]]; then
	echo "71,,,,Y"
else
	[[ -e /etc/ssh/sshd_config ]] && echo "71,,,,N, File exists" || echo "71,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#72
(if [[ $(egrep -o "ClientAliveInterval 900" /etc/ssh/sshd_config) = "ClientAliveInterval 900" ]]; then
	echo "72,,,,Y"
else
	[[ -e /etc/ssh/sshd_config ]] && echo "72,,,,N, File exists" || echo "72,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#73
(if [[ $(egrep -o "PermitEmptyPasswords no" /etc/ssh/sshd_config) = "PermitEmptyPasswords no" ]]; then
	echo "73,,,,Y"
else
	[[ -e /etc/ssh/sshd_config ]] && echo "73,,,,N, File exists" || echo "73,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#74
(if [[ $(audtitd chkconfig) = "on" ]]; then 
	echo "74,,,,Y"
else 
	echo "74,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#75 
(if [[ $(egrep "/var/log/faillog" /etc/audit/audit.rules) = "-w /var/log/faillog -p wa -k logins" ]] && [[ $(egrep "/var/log/lastlog" /etc/audit/audit.rules) = "-w /var/log/lastlog -p wa -k logins" ]]; then 
	echo "75,,,,Y"
else	
	[[ -e /etc/audit/audit.rules ]] && echo "75,,,,N, File exists" || echo "75,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#76
(if [[ $(egrep utmp /etc/audit/audit.rules) = "-w /var/run/utmp -p wa -k session" ]] && 
[[ $(egrep btmp /etc/audit/audit.rules) = "-w /var/log/btmp -p wa -k session" ]] && 
[[ $(egrep wtmp /etc/audit/audit.rules) = "-w /var/log/wtmp -p wa -k session" ]]; then 
	echo "76,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "76,,,,N, File exists" || echo "76,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt
 
#77
(if [[ $(egrep faillog /etc/audit/audit.rules) = "-w /var/log/faillog -p wa -k logins" ]] && 
[[ $(egrep lastlog /etc/audit/audit.rules) = "-w /var/log/lastlog -p wa -k logins" ]]; then
	echo "77,,,,Y" 
else 
	[[ -e /etc/audit/audit.rules ]] && echo "77,,,,N, File exists" || echo "77,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#78
(if [[ $(egrep localtime /etc/audit/audit.rules) = "-w /etc/localtime -p wa -k time-change" ]]; then
	echo "78,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "78,,,,N, File exists" || echo "78,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#79
(if [[ $(grep audit_network_modifications /etc/audit/audit.rules | sed -n 6p ) = "-w /etc/sysconfig/network -p wa -k audit_network_modifications" ]]; then 
	echo "79,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "79,,,,N, File exists" || echo "79,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#80
(if [[ $(egrep selinux /etc/audit/audit.rules) = "-w /etc/selinux/ -p wa -k MAC-policy" ]]; then
	echo "80,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "80,,,,N, File exists" || echo "80,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#81
(if [[ $(grep -e "lchown" /etc/audit/audit.rules | head -n 1) = "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod" ]]; then
	echo "81,,,,Y"
else 
	[[ -e /etc/audit/audit.rules ]] && echo "81,,,,N, File exists" || echo "81,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#82
(if [[ $(egrep -o openat /etc/audit/audit.rules | head -n 1) = "openat" ]]; then
	echo "82,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "82,,,,N, File exists" || echo "82,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#83
(if [[ $(egrep -o priv /etc/audit/audit.rules | head -n 1) = "priv" ]]; then
	echo "83,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "83,,,,N, File exists" || echo "83,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#84
(if [[ $(egrep -o mount /etc/audit/audit.rules | head -n 1) = "mount" ]]; then
	echo "84,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "84,,,,N, File exists" || echo "84,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#85
(if [[ $(egrep -o delete /etc/audit/audit.rules | head -n 1) = "delete" ]]; then
	echo "85,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "85,,,,N, File exists" || echo "85,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#86
(if [[ $(egrep -e sudoers /etc/audit/audit.rules | sed -n 1p ) = "-w /etc/sudoers" ]]; then
	echo "86,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "86,,,,N, File exists" || echo "86,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#87
(if [[ $(egrep -e insmod /etc/audit/audit.rules) = "-w /sbin/insmod -p x -k modules" ]] && 
[[ $(egrep -e rmmod /etc/audit/audit.rules) = "-w /sbin/rmmod -p x -k modules" ]] &&  
[[ $(egrep -e modprobe /etc/audit/audit.rules | sed -n 2p ) = "-w /sbin/modprobe -p x -k modules" ]] && 
[[ $(egrep -e module /etc/audit/audit.rules | sed -n 3p ) = "-w /sbin/modprobe -p x -k modules" ]]; then
	echo "87,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "87,,,,N, File exists" || echo "87,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#88
(if [[ $(egrep -o usermod /etc/audit/audit.rules) = "usermod" ]] && 
[[ $(egrep -o groupmod /etc/audit/audit.rules) = "groupmod" ]]; then 
	echo "88,,,,Y"
else
	[[ -e /etc/audit/audit.rules ]] && echo "88,,,,N, File exists" || echo "88,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#89 
(if [[ $(egrep -o useradd /etc/audit/audit.rules) = "useradd" ]] && 
[[ $(egrep -o groupadd /etc/audit/audit.rules) = "groupadd" ]]; then
	echo "89,,,,Y"
else 
	[[ -e /etc/audit/audit.rules ]] && echo "89,,,,N, File exists" || echo "89,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#90
(if [[ $(cat /etc/ntp.conf | sed -n '71p' | awk '{print $1}' ) = "server" ]]; then
	echo "90,,,,Y"
else 
	[[ -e /etc/ntp.conf ]] && echo "90,,,,N, File exists" || echo "90,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#91
(if [[ $(chkconfig kdump off) = "unknown service" ]]; then 
	echo "91,,,,Y"
else 
	echo "91,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#92
(if [[ $(rpm -q telnet-server) = "package telnet-server is not installed" ]]; then
	echo "92,,,,Y"
else 
	echo "92,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#93
(if [[ $(rpm -q rsh-server) = "package rsh-server is not installed" ]]; then
	echo "93,,,,Y"
else 
	echo "93,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#94
(if [[ $(rpm -q ypserv) = "package ypserv is not installed" ]]; then
	echo "94,,,,Y"
else 
	echo "94,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#95
(if [[ $(rpm -q tftp-server) = "package tftp-server is not installed" ]]; then
	echo "95,,,,Y"
else 
	echo "95,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#96
(if [[ $(rpm -q xinetd) = "package xinetd is not installed" ]]; then
	echo "96,,,,Y"
else 
	echo "96,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#97
(if [[ $(stat --format '%a' /etc/modprobe.d/blacklist-usb-storage.conf) -le 644 ]] && 
[[ $(ls -A /etc/modprobe.d/blacklist-usb-storage.conf) ]]; then 
	echo "97,,,,Y"
else 
	[[ -e /etc/modprobe.d/blacklist-usb-storage.conf ]] && echo "97,,,,N, File exists" || echo "97,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#98
(if [[ $(stat --format '%a' /etc/modprobe.d/blacklist-wireless.conf) -le 644 ]] && 
[[ $(ls -A /etc/modprobe.d/blacklist-wireless.conf) ]]; then 
	echo "98,,,,Y"
else 
	[[ -e /etc/modprobe.d/blacklist-wireless.conf ]] && echo "98,,,,N, File exists" || echo "98,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#99 
(if [[ $(stat --format '%a' /etc/modprobe.d/blacklist-fs.conf) -le 644 ]] && 
[[ $(ls -A /etc/modprobe.d/blacklist-fs.conf) ]]; then 
	echo "99,,,,Y"
else 
	[[ -e /etc/modprobe.d/blacklist-fs.conf ]] && echo "99,,,,N, File exists" || echo "99,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 
	
#100 
(if [[ $(chkconfig iptables) = "iptables on" ]]; then 
	echo "100,,,,Y"
else 
	echo "100,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#101
(if [[ $(egrep -e ":INPUT DROP" /etc/sysconfig/iptables) = ":INPUT DROP [0:0]" ]] && 
[[ $(egrep -e ":FORWARD DROP" /etc/sysconfig/iptables) = ":FORWARD DROP [0:0]" ]]; then
	echo "101,,,,Y"
else 	
	[[ -e /etc/sysconfig/iptables ]] && echo "101,,,,N, File exists" || echo "101,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#102
(if [[ $(grep "NETWORKING_IPV6=no" /etc/sysconfig/network) = "NETWORKING_IPV6=no" ]] || 
[[ $(grep net.ipv6.conf.all.disable_ipv6  /etc/sysctl.conf) = "net.ipv6.conf.all.disable_ipv6 = 1" ]] ||
[[ $(grep "IPV6INIT=no" /etc/sysconfig/network) = "IPV6INIT=no" ]]; then 
	echo "102,,,,Y"
else 
	[[ -e /etc/sysconfig/network ]] && echo "102,,,,N, File exists" || echo "102,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#103
(if [[ $(grep net.ipv4.ip_forward /etc/sysctl.conf) = "net.ipv4.ip_forward = 0" ]]; then 
	echo "103,,,,Y"
else
	[[ -e /etc/sysctl.conf ]] && echo "103,,,,N, File exists" || echo "103,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#104
(if [[ $(egrep -o "net.ipv4.conf.all.send_redirects = 0" /etc/sysctl.conf) = "net.ipv4.conf.all.send_redirects = 0" ]] && 
[[ $(egrep -o "net.ipv4.conf.default.send_redirects = 0" /etc/sysctl.conf) = "net.ipv4.conf.default.send_redirects = 0" ]]; then 
	echo "104,,,,Y"
else 
	[[ -e /etc/sysctl.conf ]] && echo "104,,,,N, File exists" || echo "104,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#105
(if [[ $(egrep -o "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.conf) = "net.ipv4.conf.all.accept_source_route = 0" ]] && 
[[ $(egrep -o "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.conf) = "net.ipv4.conf.default.accept_source_route = 0" ]]; then
	echo "105,,,,Y"
else 
	[[ -e /etc/sysctl.conf ]] && echo "105,,,,N, File exists" || echo "105,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#106
(if [[ $(egrep -o "net.ipv4.conf.all.accept_redirects = 0" /etc/sysctl.conf) = "net.ipv4.conf.all.accept_redirects = 0" ]] && 
[[ $(egrep -o "net.ipv4.conf.default.accept_redirects = 0" /etc/sysctl.conf) = "net.ipv4.conf.default.accept_redirects = 0" ]]; then 
	echo "106,,,,Y"
else 
	[[ -e /etc/sysctl.conf ]] && echo "106,,,,N, File exists" || echo "106,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  
 
#107
(if [[ $(egrep "net.ipv4.conf.all.secure_redirects = 0" /etc/sysctl.conf) = "net.ipv4.conf.all.secure_redirects = 0" ]] && 
[[ $(egrep -o "net.ipv4.conf.default.secure_redirects = 0" /etc/sysctl.conf) = "net.ipv4.conf.default.secure_redirects = 0" ]]; then
	echo "107,,,,Y"
else
	[[ -e /etc/sysctl.conf ]] && echo "107,,,,N, File exists" || echo "107,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt   

#108
(if [[ $(egrep -o "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.conf) = "net.ipv4.conf.all.log_martians = 1" ]] && 
[[ $(egrep -o "net.ipv4.conf.default.log_martians = 1" /etc/sysctl.conf) = "net.ipv4.conf.default.log_martians = 1" ]]; then
	echo "108,,,,Y"
else
	[[ -e /etc/sysctl.conf ]] && echo "108,,,,N, File exists" || echo "108,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#109
(if [[ $(egrep net.ipv4.icmp_echo_ignore_broadcasts /etc/sysctl.conf) = "net.ipv4.icmp_echo_ignore_broadcasts = 1" ]]; then
	echo "109,,,,Y"
else
	[[ -e /etc/sysctl.conf ]] && echo "109,,,,N, File exists" || echo "109,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#110
(if [[ $(egrep -o "net.ipv4.icmp_ignore_bogus_error_responses = 1" /etc/sysctl.conf) = "net.ipv4.icmp_ignore_bogus_error_responses = 1" ]]; then 
	echo "110,,,,Y"
else 		
	[[ -e /etc/sysctl.conf ]] && echo "110,,,,N, File exists" || echo "110,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#111
(if [[ $(grep -o "net.ipv4.conf.all.rp_filter" /etc/sysctl.conf) = "net.ipv4.conf.all.rp_filter = 1" ]] && 
[[ $(grep "net.ipv4.conf.default.rp_filter" /etc/sysctl.conf) = "net.ipv4.conf.default.rp_filter = 1" ]]; then 
	echo "111,,,,Y"
else
	[[ -e /etc/sysctl.conf ]] && echo "111,,,,N, File exists" || echo "111,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#112
(if [[ $(egrep -o "net.ipv4.tcp_syncookies = 1" /etc/sysctl.conf) = "net.ipv4.tcp_syncookies = 1" ]]; then
	echo "112,,,,Y"
else
	[[ -e /etc/sysctl.conf ]] && echo "112,,,,N, File exists" || echo "112,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#113
(if [[ $(grep -o id:3:initdefault /etc/inittab) = "id:3:initdefault" ]]; then 
	echo "113,,,,Y"
else
	echo "113,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#114
(if [[ $(egrep -o id:3:initdefault /etc/inittab) = "id:3:initdefault" ]]; then
	echo "114,,,,Y"
else
	[[ -e /etc/inittab ]] && echo "114,,,,N, File exists" || echo "114,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

echo "115,,,,Y" >> $output  2>/tmp/RESULTS/errors.txt  

#116
(if [[ $(grep "^log_file" /etc/audit/auditd.conf) = "log_file = /var/log/audit/audit.log" ]]; then 
	echo "116,,,,Y"
else	
	[[ -e /etc/audit/auditd.conf ]] && echo "116,,,,N, File exists" || echo "116,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#117
(if [[ $(stat --format '%a' /var/log/audit) -le 640 ]]; then 
	echo "117,,,,Y"
 else 
	[[ -e /var/log/audit ]] && echo "117,,,,N, File exists" || echo "117,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt    	 

#118
(if [[ $(grep "^log_file" /etc/audit/auditd.conf | sed s/^[^\/]*// | xargs stat -c %G:%n) = "root:/var/log/audit/audit.log" ]]; then 
	echo "118,,,,Y"
else 
	[[ -e /etc/audit/auditd.conf ]] && echo "118,,,,N, File exists" || echo "118,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#119
(if [[ $(ls -l / | wc -l) -ge 0 ]]; then 
	echo "119,,,,Y"
else
	echo "119,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#120
(if [[ $(stat --format '%a' /home/*) -le 750 ]]; then 
	echo "120,,,,Y"
else 
	echo "120,,,,N, Permissions set to $(stat --format '%a' /home)"
fi) >> $output  2>/tmp/RESULTS/errors.txt    

#121
(if [[ $(ls -l /home | wc -l) -ge 0 ]]; then
	echo "121,,,,Y"
else 
	echo "121,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#122
(if [[ $(stat --format '%a' /home) -le 755 ]]; then 
	echo "122,,,,Y"
else 
	echo "122,,,,N, Permissions set to $(stat --format '%a' /home)"
fi) >> $output  2>/tmp/RESULTS/errors.txt    

#123
(if [[ $(cat /etc/shells | xargs -n1 ls –l | wc -l) -ge 0 ]]; then 
	echo "123,,,,Y"
else
	[[ -e /etc/shells ]] && echo "123,,,,N, File exists" || echo "123,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#124 
(if [[ $(find /etc/shells -user root | wc -l) -ge 1 ]]; then 
	echo "124,,,,Y"
else 
	[[ -e /etc/shells ]] && echo "124,,,,N, File exists" || echo "124,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#125
(if [[ $(ls -A /etc/shells | grep "^.\{11\}[+]") ]]; then
	[[ -e /etc/shells ]] && echo "125,,,,N, File exists" || echo "125,,,,N, File does not exists" 
else 
	echo "125,,,,Y" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#126
(if [[ $(stat --format '%a' /boot/grub/grub.conf) = 600 ]]; then 
	echo "126,,,,Y"
else 
	echo "126,,,,N, Permissions set to $(stat --format '%a' /home)"
fi) >> $output  2>/tmp/RESULTS/errors.txt    

#127
(if [[ $(find /boot/grub/grub.conf -user root | wc -l) -ge 1 ]]; then
	echo "127,,,,Y" 
else 
	[[ -e /boot/grub/grub.conf ]] && echo "127,,,,N, File exists" || echo "127,,,,N, File does not exists"  
fi) >> $output  2>/tmp/RESULTS/errors.txt

#128
(if [[ $(find /boot/grub/grub.conf -user root | wc -l) -ge 1 ]]; then
	echo "128,,,,Y" 
else 
	[[ -e /boot/grub/grub.conf ]] && echo "128,,,,N, File exists" || echo "128,,,,N, File does not exists"  
fi) >> $output  2>/tmp/RESULTS/errors.txt

#129
(if [[ $(ls -A /boot/grub/grub.conf | grep "^.\{11\}[+]") ]]; then
	echo "129,,,,Y" 
else 
	[[ -e /boot/grub/grub.conf ]] && echo "129,,,,N, File exists" || echo "129,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#130
(if [[ $(stat --format '%a' /etc/security/access.conf) -le 640 ]]; then 
	echo "130,,,,Y"
else 
	echo "130,,,,N, Permissions set to $(stat --format '%a' /etc/security/access.conf)" || [ -f /etc/security/access.conf ]] && echo "File exists" || echo "File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt    

#131
(if [[ $(find /etc/security/access.conf -user root | wc -l) -ge 1 ]]; then
	echo "131,,,,Y"
else 
	[[ -e /etc/security/access.conf ]] && echo "131,,,,N, File exists" || echo "131,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#132
(if [[ $(find /etc/security/access.conf -user root | wc -l) -ge 1 ]]; then
	echo "132,,,,Y"
else 
	[[ -e /etc/security/access.conf ]] && echo "132,,,,N, File exists" || echo "132,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#133
(if [[ $(ls -l /etc/security/access.conf | grep "^.\{11\}[+]") ]]; then
	[[ -e /etc/security/access.conf ]] && echo "133,,,,N, File exists" || echo "133,,,,N, File does not exists"
else 
	echo "133,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#134
(if [[ $(stat --format '%a' /etc/group) -le 640 ]]; then 
	echo "134,,,,Y"
else 
	echo "134,,,,N, Permission set to $(stat --format '%a' /etc/group)" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#135
(if [[ $(find /etc/group -user root | wc -l) -ge 1 ]]; then
	echo "135,,,,Y" 
else 
	[[ -e /etc/group ]] && echo "135,,,,N, File exists" || echo "135,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#136
(if [[ $(find /etc/group -user root | wc -l) -ge 1 ]]; then
	echo "136,,,,Y" 
else 
	[[ -e /etc/group ]] && echo "136,,,,N, File exists" || echo "136,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#137
(if [[ $(ls -l /etc/group | grep "^.\{11\}[+]") ]]; then
	[[ -e /etc/group ]] && echo "137,,,,N, File exists" || echo "137,,,,N, File does not exists"
else 
	echo "137,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#138
(if [[ $(stat --format '%a' /etc/gshadow) = 0000 ]]; then
	echo "138,,,,Y" 
else 
	[[ -e /etc/gshadow ]] && echo "138,,,,N, File exists" || echo "138,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#139
(if [[ $(find /etc/gshadow -user root | wc -l) -ge 1 ]]; then
	echo "139,,,,Y" 
else 
	[[ -e /etc/gshadow ]] && echo "139,,,,N, File exists" || echo "139,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#140
(if [[ $(find /etc/gshadow -user root | wc -l) -ge 1 ]]; then
	echo "140,,,,Y" 
else 
	[[ -e /etc/gshadow ]] && echo "140,,,,N, File exists" || echo "140,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#141
(if [[ $(ls -l /etc/gshadow | grep "^.\{11\}[+]") ]]; then
	echo "141,,,,Y"
else 
	[[ -e /etc/gshadow ]] && echo "141,,,,N, File exists" || echo "141,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#142
(if [[ $(stat --format '%a' /etc/hosts) -le 644 ]]; then 
	echo "142,,,,Y"
else 
	echo "142,,,,N, Permission set to $(stat --format '%a' /etc/hosts)" || [[ -e /etc/hots ]] && echo "142,,,,N, File exists" || echo "142,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#143
(if [[ $(find /etc/hosts -user root | wc -l) -ge 1 ]]; then
	echo "143,,,,Y" 
else 
	[[ -e /etc/hots ]] && echo "143,,,,N, File exists" || echo "143,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#144
(if [[ $(find /etc/hosts -user root | wc -l) -ge 1 ]]; then
	echo "144,,,,Y" 
else 
	[[ -e /etc/hots ]] && echo "144,,,,N, File exists" || echo "144,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#145
(if [[ $(ls -l /etc/hosts | grep "^.\{11\}[+]") ]]; then
	[[ -e /etc/hots ]] && echo "145,,,,N, File exists" || echo "145,,,,N, File does not exists"
else 
	echo "145,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#146
(if [[ $(stat --format '%a' /etc/passwd) -le 644 ]]; then 
	echo "146,,,,Y"
else 
	echo "146,,,,N, Permission set to $(stat --format '%a' /etc/passwd)" || [[ -e /etc/passwd ]] && echo "146,,,,N, File exists" || echo "146,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#147
(if [[ $(find /etc/passwd -user root | wc -l) -ge 1 ]]; then
	echo "147,,,,Y" 
else 
	[[ -e /etc/passwd ]] && echo "147,,,,N, File exists" || echo "147,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#148
(if [[ $(find /etc/passwd -user root | wc -l) -ge 1 ]]; then
	echo "148,,,,Y" 
else 
	[[ -e /etc/passwd ]] && echo "148,,,,N, File exists" || echo "148,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#149
(if [[ $(ls -l /etc/passwd | grep "^.\{11\}[+]") ]]; then
	[[ -e /etc/passwd ]] && echo "149,,,,N, File exists" || echo "149,,,,N, File does not exists"
else 
	echo "149,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#150
(if [[ $(stat --format '%a' /etc/resolv.conf) -le 644 ]]; then 
	echo "150,,,,Y"
else 
	echo "150,,,,N, Permission set to $(stat --format '%a' /etc/resolv.conf)" || [[ -e /etc/resolv.conf ]] && echo "150,,,,N, File exists" || echo "150,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#151
(if [[ $(find /etc/resolv.conf -user root | wc -l) -ge 1 ]]; then
	echo "151,,,,Y" 
else 
	[[ -e /etc/resolv.conf ]] && echo "151,,,,N, File exists" || echo "151,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt    

#152
(if [[ $(find /etc/resolv.conf -user root | wc -l) -ge 1 ]]; then
	echo "152,,,,Y" 
else 
	[[ -e /etc/resolv.conf ]] && echo "152,,,,N, File exists" || echo "152,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#153
(if [[ $(ls -lh /etc/resolv.conf | grep "^.\{11\}[+]") = "+" ]]; then
	[[ -e /etc/resolv.conf ]] && echo "152,,,,N, File exists" || echo "152,,,,N, File does not exists"
else 
	echo "153,,,,Y" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#154
(if [[ $(stat --format '%a' /etc/securetty) -le 600 ]]; then 
	echo "154,,,,Y"
else 
	echo "154,,,,N, Permission set to $(stat --format '%a' /etc/securetty)" || [[ -e /etc/securetty ]] && echo "154,,,,N, File exists" || echo "154,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#155
(if [[ $(find /etc/securetty -user root | wc -l) -ge 1 ]]; then
	echo "155,,,,Y" 
else 
	[[ -e /etc/securetty ]] && echo "155,,,,N, File exists" || echo "155,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#156
(if [[ $(find /etc/securetty -user root | wc -l) -ge 1 ]]; then
	echo "156,,,,Y" 
else 
	[[ -e /etc/securetty ]] && echo "156,,,,N, File exists" || echo "156,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#157 
(if [[ $(ls -lh /etc/securetty | grep "^.\{11\}[+]") = "+" ]]; then
	[[ -e /etc/securetty ]] && echo "157,,,,N, File exists" || echo "157,,,,N, File does not exists"
else 
	echo "157,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#158
(if [[ $(stat --format '%a' /etc/shadow) -eq 0 ]]; then
	echo "158,,,,Y" 
else 
	echo "158,,,,N, Permission set to $(stat --format '%a' /etc/shadow)" || [[ -e /etc/shadow ]] && echo "158,,,,N, File exists" || echo "158,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#159
(if [[ $(find /etc/shadow -user root | wc -l) -ge 1 ]]; then
	echo "159,,,,Y" 
else 
	[[ -e /etc/shadow ]] && echo "159,,,,N, File exists" || echo "159,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#160
(if [[ $(find /etc/shadow -user root | wc -l) -ge 1 ]]; then
	echo "160,,,,Y" 
else
	[[ -e /etc/shadow ]] && echo "160,,,,N, File exists" || echo "160,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#161
(if [[ $(ls -lh /etc/shadow | grep "^.\{11\}[+]") = "+" ]]; then
	[[ -e /etc/shadow ]] && echo "161,,,,N, File exists" || echo "161,,,,N, File does not exists"
else 
	echo "161,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#162
(if [[ $(stat --format '%a' /etc/sysctl.conf) -le 600 ]]; then 
	echo "162,,,,Y"
else 
	echo "162,,,,N, Permission set to $(stat --format '%a' /etc/sysctl.conf)" || [[ -e /etc/sysctl.conf ]] && echo "162,,,,N, File exists" || echo "162,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#163
(if [[ $(find /etc/sysctl.conf -user root | wc -l) -ge 1 ]]; then
	echo "163,,,,Y" 
else 
	[[ -e /etc/sysctl.conf ]] && echo "163,,,,N, File exists" || echo "163,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#164
(if [[ $(find /etc/sysctl.conf -user root | wc -l) -ge 1 ]]; then
	echo "164,,,,Y" 
else 
	[[ -e /etc/sysctl.conf ]] && echo "164,,,,N, File exists" || echo "164,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#165
(if [[ $(ls -lh /etc/sysctl.conf | grep "^.\{11\}[+]") = "+" ]]; then
	[[ -e /etc/sysctl.conf ]] && echo "165,,,,N, File exists" || echo "165,,,,N, File does not exists"
else 
	echo "165,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#166
(if [[ $(stat --format '%a' /etc/rsyslog.conf) = 640 ]]; then 
	echo "166,,,,Y"
else 
	[[ -e /etc/rsyslog.conf ]] && echo "166,,,,N, File exists" || echo "166,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#167
(if [[ $(find /etc/rsyslog.conf -user root | wc -l) -ge 1 ]]; then
	echo "167,,,,Y" 
else 
	[[ -e /etc/rsyslog.conf ]] && echo "167,,,,N, File exists" || echo "167,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#168
(if [[ $(find /etc/rsyslog.conf -user root | wc -l) -ge 1 ]]; then
	echo "168,,,,Y" 
else 
	[[ -e /etc/rsyslog.conf ]] && echo "168,,,,N, File exists" || echo "168,,,,N, File does not exists"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#169
(if [[ $(ls -lh /etc/rsyslog.conf | grep "^.\{11\}[+]") = "+" ]]; then
	[[ -e /etc/rsyslog.conf ]] && echo "169,,,,N, File exists" || echo "169,,,,N, File does not exists"
else 
	echo "169,,,,Y" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#170
(if [[ $(stat --format '%a' /etc/csh.cshrc) -le 644 ]]; then
	echo "170,,,,Y" 
else 
	[[ -e /etc/csh.cshrc ]] && echo "170,,,,N, File exists" || echo "170,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#171
(if [[ $(find /etc/csh.cshrc -user root | wc -l) -ge 1 ]]; then
	echo "171,,,,Y" 
else 
	[[ -e /etc/csh.cshrc ]] && echo "171,,,,N, File exists" || echo "171,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#172
(if [[ $(find /etc/csh.cshrc -user root | wc -l) -ge 1 ]]; then
	echo "172,,,,Y" 
else 
	[[ -e /etc/csh.cshrc ]] && echo "172,,,,N, File exists" || echo "172,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#173
(if [[ $(ls -lh | grep "^.\{11\}[+]") = "+" ]]; then
	echo "173,,,,N"
else
	echo "173,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#174
(if [[ $(stat --format '%a' /etc/services) -le 644 ]]; then 
	echo "174,,,,Y"
else 
	echo "174,,,,N, Permission set to $(stat --format '%a' /etc/services)" || [[ -e /etc/services ]] && echo "174,,,,N, File exists" || echo "174,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#175
(if [[ $(find /etc/services -user root | wc -l) -ge 1 ]]; then
	echo "175,,,,Y" 
else 
	[[ -e /etc/services ]] && echo "175,,,,N, File exists" || echo "175,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt

#176
(if [[ $(find /etc/services -user root | wc -l) -ge 1 ]]; then
	echo "176,,,,Y" 
else 
	[[ -e /etc/services ]] && echo "176,,,,N, File exists" || echo "176,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt

#177
(if [[ $(ls -lh /etc/services | grep "^.\{11\}[+]") = "+" ]]; then
	[[ -e /etc/services ]] && echo "177,,,,N, File exists" || echo "177,,,,N, File does not exists"  
else 
	echo "177,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#178
(if [[ $(stat --format '%a' /etc/crontab) -le 600 ]]; then 
	echo "178,,,,Y"
else 
	echo "178,,,,N, Permissions set to $(stat --format '%a' /etc/crontab)" || [[ -e /etc/crontab ]] && echo "178,,,,N, File exists" || echo "178,,,,N, File does not exists"  
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#179
(if [[ $(find /etc/crontab -user root | wc -l) -ge 1 ]]; then
	echo "179,,,,Y" 
else 
	[[ -e /etc/crontab ]] && echo "179,,,,N, File exists" || echo "179,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt

#180
(if [[ $(find /etc/crontab -user root | wc -l) -ge 1 ]]; then
	echo "180,,,,Y" 
else 
	[[ -e /etc/crontab ]] && echo "180,,,,N, File exists" || echo "180,,,,N, File does not exists" 
fi) >> $output  2>/tmp/RESULTS/errors.txt

#181
(if [[ $(find / -xdev -perm -2000 -type f –print | wc -l) -ge 0 ]]; then
	echo "181,,,,Y"
else
	echo "181,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt  

#182
(if [[ $(find / -xdev -perm -4000 -type f -print | wc -l) -ge 0 ]]; then 
	echo "182,,,,Y"
else
	echo "182,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt 

#183
(if [[ $(find / -xdev \( -nouser -o -nogroup \) -print | wc -l) -ge 0 ]]; then 
	echo "183,,,,Y"
else
	echo "183,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt

#184
(if [[ $(grep umask /etc/* | awk '{print $2}' ) = "077" ]]; then 
	echo "184,,,,Y"
else 
	echo "184,,,,N"
fi) >> $output  2>/tmp/RESULTS/errors.txt
 
#185
(if [[ $(find / -xdev -type f -perm -002 | wc -l) -ge 1 ]]; then 
	echo "185,,,,N, There are world-writtable files on this machine"
else 
	echo "185,,,,Y"
fi) >> $output  2>/tmp/RESULTS/errors.txt
 
#186
(if [[ $(stat --format '%a' /tmp ) -eq 1777 ]] && 
[[ $(stat --format '%a' /etc ) -eq 1777 ]] && 
[[ $(stat --format '%a' /var ) -eq 1777 ]] && 
[[ $(stat --format '%a' /var/tmp ) -eq 1777 ]] && 
[[ $(stat --format '%a' /proc ) -eq 1777 ]] && 
[[ $(stat --format '%a' /bin ) -eq 1777 ]] && 
[[ $(stat --format '%a' /boot ) -eq 1777 ]] && 
[[ $(stat --format '%a' /dev/shm ) -eq 1777 ]]; then 
	echo "186,,,,Y" 
else
	echo "186,,,,N, Permissions set to /tmp $(stat --format '%a' /tmp ) , /etc $(stat --format '%a' /etc ) , /var $(stat --format '%a' /var ) , /var/tmp $(stat --format '%a' var/tmp ), /proc $(stat --format '%a' /proc ), /bin $(stat --format '%a' /bin ), /boot $(stat --format '%a' /boot ), /dev/shm $(stat --format '%a' /dev/shm )" 
fi) >> $output  2>/tmp/RESULTS/errors.txt
  
#187
(if [[ $(ls -l /home | wc -l ) -ge 1 ]]; then
	echo "187,,,,Y"
else
	echo "187,,,,N"

fi) >> $output  2>/tmp/RESULTS/errors.txt

chmod -R 777 $output 
echo -e "Completed results located at $output"