@ECHO OFF
CLS
:MENU
ECHO.
ECHO ...............................................
ECHO.
ECHO      Create folder structures for RMF 4 team
ECHO.
ECHO ...............................................
ECHO.
ECHO PRESS 1, 2 OR 3 to select your task, or 4 to EXIT.
ECHO.
ECHO ...............................................
ECHO.
ECHO 1 - AA (Full)
ECHO 2 - STA (streamlined)
ECHO 3 - TA (targeted)
ECHO 4 - EXIT
ECHO.

SET /P M=Type 1, 2, 3, or 4 then press ENTER: 
IF %M%==1 GOTO AA
IF %M%==2 GOTO STA
IF %M%==3 GOTO TA
IF %M%==4 GOTO EOF

:AA
SET /P A=Enter system acronym: 
SET /P N=Enter system version: 
SET LOC="\\causers\doshare\CA ISSO Security Team\Certification Team\%A%\%N%\Full_AA\"
SET TEM="\\causers\doshare\CA ISSO Security Team\Certification Team\Templates"
SET IRM="\\irm.m.state.sbu\sites\ia\Docs\Documents"
GOTO BUILD

:STA
SET /P A=Enter system acronym: 
SET /P N=Enter system version: 
SET LOC="\\causers\doshare\CA ISSO Security Team\Certification Team\%A%\%N%\STA\"
SET TEM="\\causers\doshare\CA ISSO Security Team\Certification Team\Templates"
SET IRM="\\irm.m.state.sbu\sites\ia\Docs\Documents"
GOTO BUILD

:TA
SET /P A=Enter system acronym: 
SET /P N=Enter system version: 
SET LOC="\\causers\doshare\CA ISSO Security Team\Certification Team\%A%\%N%\TA\"
SET TEM="\\causers\doshare\CA ISSO Security Team\Certification Team\Templates"
SET IRM="\\irm.m.state.sbu\sites\ia\Docs\Documents"
GOTO BUILD

:BUILD
(
mkdir %LOC%\"RMF 1-3\Emails"
mkdir %LOC%\"RMF 1-3\Final"
copy %TEM%\"SCAP Template.docx" %LOC%\"RMF 1-3"
copy %IRM%\"Detailed ISCP Review Criteria.docx" %LOC%\"RMF 1-3"
copy %IRM%\"Detailed SSP Review Criteria.doc" %LOC%\"RMF 1-3"
copy %IRM%\"SCF PIA Review Checklist.docx" %LOC%\"RMF 1-3"
copy %IRM%\"PIA Request - Bureau name -  Application name Version ITAB Number.msg" %LOC%\"RMF 1-3\Emails"

mkdir %LOC%\"RMF 4\Checklists"
mkdir %LOC%\"RMF 4\Screenshots"
mkdir %LOC%\"RMF 4\Emails"
mkdir %LOC%\"RMF 4\Final"
mkdir %LOC%\"RMF 4\Tester\Archive"
copy %TEM%\"SAR Template.docx" %LOC%\"RMF 4"
copy %TEM%\"RMF Step 4 Resources.doc" %LOC%\"RMF 4"
copy %TEM%\"RMF Step 4 Resources_internal script.doc" %LOC%\"RMF 4"
copy %TEM%\"Interview-Demo_Template.docx" %LOC%\"RMF 4"
copy %TEM%\"AIS Assessment Boundary.docx" %LOC%\"RMF 4"
copy %TEM%\"Documentation_Change_Request.docx" %LOC%\"RMF 4"
copy %IRM%\"Draft Findings in POAM Format email to System Owner.msg" %LOC%\"RMF 4"

mkdir %LOC%\"RMF 5"
copy %IRM%\"ACCREDITATION REPORT for Low Impact Systems.doc" %LOC%\"RMF 5"
copy %IRM%\"ACCREDITATION REPORT for High and Medium Impact Systems.doc" %LOC%\"RMF 5"
copy %IRM%\"ACCREDITATION REPORT for Significant Change to High and Medium Systems.docx" %LOC%\"RMF 5"
copy %IRM%\"Exit Criteria for Accreditation Phase based on 800-37.doc" %LOC%\"RMF 5"
) >nul
ECHO Created %LOC%
GOTO MENU

:EOF
exit /b