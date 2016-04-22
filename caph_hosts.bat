@ECHO OFF
SET HOST=\\causers\users\bryanttn\caph
SET U=ca\caadmbryanttn
SET P=CAB$winter14! 
(ECHO HOSTNAME:	USER:
FOR /F "tokens=2" %%A IN (%HOST%) DO (
	ECHO %%A
	wmic /node:%%A useraccount get localaccount
	)
)