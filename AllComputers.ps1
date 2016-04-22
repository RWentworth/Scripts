import-module activedirectory
get-adcomputer -property CN,OperatingSystem -filter * |export-csv c:\temp\allcomps.csv –notypeinformation
