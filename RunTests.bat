"C:\Program Files\Dyalog\Dyalog APL-64 18.0 Unicode\Dyalog.exe" maxws=200MB load="APLSource/Admin/LoadTatinAndRunTests.aplf" lx="1 #.LoadTatinAndRunTests 1" OFF=1 -x 

IF %ERRORLEVEL% NEQ 0 ( 
   echo "Tatin test suite failed"
)