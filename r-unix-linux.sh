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
		echo "#,Configuration Item,Requirement,Comments,Y/N" >> $FILE
		echo "1,Physical access,Physically restrict and limit access to computer hardware according to 12 FAM 625.1.,FAM - Physical Security: Access Control and Media Protection,Y" >> $FILE
		echo "2,Hardware,Only hardware listed on the ITCCB approved hardware list shall be used with a system running RHEL.,ITCCB - ITCCB Hardware Baseline,Y" >> $FILE
		echo "3,Configuration prior to connecting to network,The system shall be configured in accordance to this document before connecting it to the DOS network.,,Y" >> $FILE
		echo "4,Regional language,The system shall have regional language set to U.S.,,Y" >> $FILE
		echo "5,The system shall follow the approved standard naming convention for its hostname.,,,Y" >> $FILE
		echo "6,Root password complexity,The root password shall conform to the 12 FAM 623.3-1 specifications: 1. Passwords must be at least 12 characters long. 2. Passwords must contain characters from at least three of the following four classes: a) English Upper Case Letters (A-Z) b) English Lower Case Letters (a-z) c) Westernized Arabic Numerals (0-9) d) Non-alphanumeric special characters.,,,"  >> $FILE
		echo "7,Root password storage,The root password shall be kept in a locked safe for system recovery and emergency maintenance.,,,"  >> $FILE
		echo "8,Separate partition for / (root),The system shall have separate partitions for / (root).,Verify through /etc/fstab,,," >> $FILE

		echo "44,Inactive accounts,The system shall lock user accounts upon 35 days of inactivity.,Verify /etc/default/useradd contains INACTIVE=35,$(if [ $(egrep INACTIVE= /etc/default/useradd) = "INACTIVE=35"]; echo "Y"; else echo "N"; fi)") >> $FILE



		chmod -R 777 /tmp/ISSO
								
	;;
		*)
		
		echo "Could not identify $server operating system version."
				
	;;	#END null
			
	esac

oscheck=
