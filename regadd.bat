@ECHO OFF
FOR /F "skip=1 tokens=1" %%A IN (z:\caph) DO (
	ECHO %%A
	reg add "\\%%A\HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing" /v State /t REG_DWORD /d 146432 /f
	reg add "\\%%A\HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v CertificateRevocation /t REG_DWORD /d 1 /f
	)