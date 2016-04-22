@ECHO OFF

rem ***DEVELOPED BY TREVOR BRYANT (PHACIL) BEGINNING MAY 2012***
rem ***USER MUST HAVE READ/WRITE ACCESS TO STAGING AREA**
rem ***USER MUST EXECUTE SCRIPT AS ADMINISTRATOR (RIGHT CLICK --> RUN AS ADMIN)***

SET CDATE=%COMPUTERNAME%_%Date:~-10,2%%Date:~-7,2%%Date:~-4,4%
SET STAMP=%COMPUTERNAME%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%_%DATE:~-10,2%%DATE:~-7,2%%DATE:~-4,4%
SET PN=\\CAPH972582\AUDIT\%COMPUTERNAME%\%STAMP%
SET MD5=\\CAPH972582\AUDIT\md5sum.exe
SET LOG=%PN%\LOG.txt

rem CREATE DIR ON STAGING AREA & CHECK TO SEE IF DIR EXISTS
ECHO STAGING LOCATION: %PN%
MKDIR %PN%
IF EXIST %PN% (GOTO START) ELSE GOTO ERR

:START
rem SCRIPT START
ECHO Script executed as user %USERDOMAIN%\%USERNAME% on device: %COMPUTERNAME% & ECHO Script executed as user %USERDOMAIN%\%USERNAME% on device: %COMPUTERNAME% > %LOG%
ECHO Script start %TIME% %DATE% & ECHO %TIME% %DATE% Script start >> %LOG%

rem EXPORT REGISTRY
ECHO Exporting REGISTRY %TIME% %DATE% & ECHO %TIME% %DATE% Exporting REGISTRY >> %LOG%
REGEDIT /E %PN%\%CDATE%_REG.txt
ECHO Exporting REGISTRY completed %TIME% %DATE% & ECHO %TIME% %DATE% Exporting REGISTRY completed >> %LOG%

rem SAVE SYSTEM INFORMATION
ECHO Saving SYSTEM INFORMATION %TIME% %DATE% & ECHO %TIME% %DATE% Saving SYSTEM INFORMATION >> %LOG%
(MSINFO32 /NFO %PN%\%CDATE%.nfo & WINMSD /NFO %PN%\%CDATE%.nfo) 2>> %LOG%
tasklist /m > %PN%\%CDATE%_PROCESSES.txt & type %SystemRoot%\system32\drivers\etc\hosts > %PN%\%CDATE%_hosts.txt & driverquery /V > %PN%\%CDATE%_DRIVERS.txt
(net users & FOR /F "delims=*" %%A IN ('net localgroup') DO net localgroup "%%A") 2>nul > %PN%\%CDATE%_USERS.txt
(echo *QUERY PROCESS: & echo. & query PROCESS & echo. & echo *QUERY SESSION: & echo. & query SESSION & echo. & echo *QUERY TERMSERVER: & echo. & query TERMSERVER & echo. & echo *QUERY USER: & echo. & query USER) > %PN%\%CDATE%_QUERY.txt
(echo SCHEDULED TASKS: & SCHTASKS /QUERY & echo. & echo SCHEDULED TASK DETAILS: & SCHTASKS /QUERY /FO LIST /V) > %PN%\%CDATE%_SCHTASKS.txt

rem WMIC COMMANDS
WMIC OS > %PN%\%CDATE%_OS.txt & WMIC environment get name,variablevalue > %PN%\%CDATE%_ENVIRONMENT.txt & WMIC service get name,pathname,state,displayname > %PN%\%CDATE%_SERVICES.txt & WMIC process get name,csname,commandline > %PN%\%CDATE%_PROCESSES2.txt & WMIC product get name,version,vendor > %PN%\%CDATE%_SOFTWARE.txt & WMIC qfe > %PN%\%CDATE%_OS_PATCHES.txt & WMIC service list full > %PN%\%CDATE%_SERVICES_CONFIG.txt
(WMIC LOGICALDISK get deviceid,volumename,providername & WMIC netuse get localname,remotepath) > %PN%\%CDATE%_DISK.txt
ECHO Saving SYSTEM INFORMATION completed %TIME% %DATE% & ECHO %TIME% %DATE% Saving SYSTEM INFORMATION completed >> %LOG%

rem SAVE WINDOWS EVENT LOGS & REMOVE EMPTY EVENT LOGS
ECHO Saving WINDOWS EVENT LOGS %TIME% %DATE% & ECHO %TIME% %DATE% Saving WINDOWS EVENT LOGS >> %LOG%
MKDIR %PN%\EVENTINFO
FOR /F "tokens=1,2 delims=/" %%j IN ('wevtutil el') DO wevtutil epl "%%j" "%PN%\EVENTINFO\%%j.evtx" 2>> %PN%\EVENTINFO\FAILED_EVENT_LOGS.txt
FOR %%i IN (%PN%\EVENTINFO\*.evtx) DO IF %%~zi LEQ 69632 (del /Q "%%i")
ECHO Saving WINDOWS EVENT LOGS completed %TIME% %DATE% & ECHO %TIME% %DATE% Saving WINDOWS EVENT LOGS completed >> %LOG%

rem SAVE NETWORK INFORMATION
ECHO Saving NETWORK INFORMATION %TIME% %DATE% & ECHO %TIME% %DATE% Saving NETWORK INFORMATION >> %LOG%
(echo *IPCONFIG: & ipconfig /all & echo. & echo. & echo *CURRENT LOCAL DNS at %CDATE%: & ipconfig /displayDNS & echo. & echo. & echo *NETSTAT -S: & netstat -s & echo. & echo. & echo *NETSTAT -R: & netstat -r & echo. & echo. & echo *NETSTAT -AB: & netstat -ab) > %PN%\%CDATE%_NIC.txt
(echo %STAMP% & net time /querysntp & echo *W32TM QUERY &echo. & w32tm /query /status & echo. & echo. & w32tm /query /peers & echo. & echo *W32TM CONFIGURATION & echo. & w32tm /query /configuration) > %PN%\%CDATE%_TIME.txt
ECHO Saving NETWORK INFORMATION completed %TIME% %DATE% & ECHO %TIME% %DATE% Saving NETWORK INFORMATION completed >> %LOG%

rem SAVE DISK INFO -- CAN TAKE MANY HOURS
ECHO Saving DISK INFO %TIME% %DATE% & ECHO %TIME% %DATE% Saving DISK INFO >> %LOG%
MKDIR %PN%\DISKINFO
FOR /F %%A IN ('dir /b M:\') DO cleartool endview "%%A" 2>nul
rem FOR /f "tokens=1 skip=1 delims=:" %%A IN ('WMIC LOGICALDISK get name') DO %MD5% -R %%A:\* > %PN%\DISKINFO\%CDATE%_MD5_%%A.txt 2>> %LOG%
FOR /f "tokens=1 skip=1 delims=:" %%A IN ('WMIC LOGICALDISK get name') DO CACLS %%A:\ /T /C > %PN%\DISKINFO\%CDATE%_ACLS_%%A.txt 2>> %LOG%
FOR /f "tokens=1 skip=1 delims=:" %%A IN ('WMIC LOGICALDISK get name') DO TREE %%A:\ /F /A > %PN%\DISKINFO\%CDATE%_TREE_%%A.txt 2>> %LOG%
FOR /f "tokens=1 skip=1 delims=:" %%A IN ('WMIC LOGICALDISK get name') DO DIR %%A:\ /S > %PN%\DISKINFO\%CDATE%_DIR_%%A.txt 2>> %LOG%
ECHO Saving DISK INFO completed %TIME% %DATE% & ECHO %TIME% %DATE% Saving DISK INFO completed >> %LOG%
GOTO END

:ERR
ECHO ERROR: Check permission levels on STAGING AREA.
GOTO END

:END
rem SCRIPT END
ECHO Script end %TIME% %DATE% & ECHO %TIME% %DATE% Script end >> %LOG%
ENDLOCAL
