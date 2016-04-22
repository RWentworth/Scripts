@ECHO OFF
mkdir C:\temp 2>nul
SET /P H=Enter hostname or IP address: 
wmic /node:%H% product get name,version,vendor > C:\temp\%H%_PRODUCT.txt
IF C:\temp\%H%_PRODUCT.txt LEQ 0 (ECHO Error: The RPC server is unavailable.) ELSE ECHO Created C:\temp\%H%_PRODUCT.txt