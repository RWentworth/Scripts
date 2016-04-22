@ECHO OFF
SET R=HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing
ECHO Host	Value	Type	Data
(FOR /F "skip=1 tokens=1" %%A IN (z:\caph) DO (
	FOR /F "tokens=*" %%B IN ('reg query "\\%%A\%R%" /v State ^| FIND "State"') DO ECHO %%A %%B
	)
)