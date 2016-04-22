@ECHO OFF
SET /P A=Enter system acronym: 
SET YY=%Date:~-4,4%
SET LOC="\\causers\doshare\CA ISSO Security Team\Certification Team\%A%\%YY%"
SET TEM="\\causers\doshare\CA ISSO Security Team\Certification Team\Templates"
SET IRM="\\irm.m.state.sbu\sites\ia\Docs\Documents"
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
pause