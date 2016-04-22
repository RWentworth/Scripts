#! /bin/sh

STAMP=`date +%m%d%Y`_`date +%H%M`

# Identify operating system version of host and execute respective checklist
server=$(hostname)
oscheck=`/bin/uname -a | egrep -o "el5|el6|AIX|3.0.101"`
	case $oscheck in
		el5) # Red Hat Enterprise Linux 5.x
		
		echo "$server is RHEL5" >> $FILE
		
	;;
		
		el6) # Red Hat Enterprise Linux 6.x
		
		echo "$server is RHEL6"

		# DO WORK

								
	;;	
		AIS) # AIX
		echo "$server is AIX" >> "$FILE"
	;;
		3.0.101) # SLES 11
		# Set VAR and MKDIR
		LOC=/tmp/ISSO/$server/"$server"_"$STAMP"
		LOG=$LOC/log.txt
		FILE=$LOC/"$server"_"$STAMP".txt
		
		mkdir -m 777 -p $LOC
		
		# DO WORK
		echo "Executed by $(whoami) on $server" >> $FILE
		uname -a >> $FILE
		echo "Executing Red Hat Enterprise Linux 6 Security Configuration Standard 1.0 8/5/2013" >> $FILE
		echo -e >> $FILE
		echo "#,,,,Y/N" >> $FILE #header
		echo "1,,,,Y" >> $FILE #1
		echo "2,,,,Y" >> $FILE #2
		echo "3,,,,Y" >> $FILE #3
		echo "4,,,,Y" >> $FILE #4
		echo "5,,,,Y" >> $FILE #5
		echo "6,,,," >> $FILE #6
		echo "7,,,," >> $FILE #7
		echo "8,,,," >> $FILE #8
		echo "9,,,," >> $FILE #9
		echo "10,,,," >> $FILE #10
		echo "11,,,," >> $FILE #11
		echo "12,,,," >> $FILE #12
		echo "13,,,," >> $FILE #13
		echo "14,,,," >> $FILE #14
		
		#15
		(if [ ! -f /boot/grub/grub.conf ]; then
			echo "15,,,,Y"
		else
			echo "15,,,,N"
		fi) >> $FILE

		echo "16,,,," >> $FILE #16
		echo "17,,,," >> $FILE #17
		echo "18,,,," >> $FILE #18
		echo "19,,,," >> $FILE #19
		echo "20,,,," >> $FILE #20
		echo "21,,,," >> $FILE #21
		echo "22,,,," >> $FILE #22
		
		#23
		(if [[ $(egrep /tmp /etc/fstab) = "/tmp /var/tmp none rw,noexec,nosuid,nodev,bind 0 0" ]]; then
			echo "23,,,,Y"
		else
			echo "23,,,,N"
		fi) >> $FILE

		echo "24,,,," >> $FILE #24
		echo "25,,,," >> $FILE #25
		
		#26
		(if [[ $(egrep nullok /etc/pam.d/system-auth) = nullok ]]; then
			echo "26,,,,Y"
		else
			echo "26,,,,N"
		fi) >> $FILE
		

		#44
		(if [ $(egrep INACTIVE= /etc/default/useradd) = "INACTIVE=35" ]; then
			echo "44,,,,Y"
		 else
			echo "44,,,,N"
		fi) >> $FILE

		#45



		chmod -R 777 /tmp/ISSO
								
	;;
		*)
		
		echo "Could not identify $server operating system version."
				
	;;	#END null
			
	esac

oscheck=
