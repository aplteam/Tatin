@echo off 

REM This script is potentially useful in order to execute the Tatin test suite in batch mode.
REM The script must be situated in the Tatin project folder, otherwise amend "load" below.
REM If a parameter is passed it must be "-debug" (case sensitive!) which is interpreted as expected.
REM This can help to identify problems that occur only when run in batch mode.
REM Do not use the Dyalog Runtime since what is tested might well attempt to write to the session.
REM # Note that a log is written in TatinBatchTests/log.txt which is created in your OS's temp folder.
REM Make sure you call the correct version of Dyalog APL.

SET parm=""

IF "%1" == "-debug" (
    SET parm="-debug" ) 

"C:\Program Files\Dyalog\Dyalog APL-64 18.0 Unicode\Dyalog.exe" maxws=200MB load="APLSource/Admin/LoadTatinAndRunTests.aplf" lx="#.LoadTatinAndRunTests" %parm% OFF=1

@echo on
IF %ERRORLEVEL% NEQ 0 ( 
   echo "Tatin test suite failed"
) ELSE (
   echo "Tatin test suite passed"
)   

:EOF