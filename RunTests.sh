#!/bin/bash

# This script is potentially useful in order to execute the Tatin test suite in batch mode.
# The script must be situated in the Tatin project folder, otherwise amend "load" below.
# If a parameter is passed it must be "-debug" (case sensitive!) which is interpreted as expected.
# This can help to identify problems that occur only when run in batch mode.
# Do not use the Dyalog Runtime since what is tested might well attempt to write to the session.
# Note that a log is written in TatinBatchTests/log.txt which is created in your OS's temp folder.
# Make sure you call the correct version of Dyalog APL.

IF [ $1 -eq "-debug" ]
    parm="-debug"
ELSE
    parm=""
FI    

"/opt/mdyalog/18.0/64/unicode/mapl" maxws=200MB load="./APLSource/Admin/LoadTatinAndRunTests.aplf" lx="#.LoadTatinAndRunTests" OFF=1 $parm 

IF [ $? -eq 0 ]
    echo "Tatin test suite passed"   
ELSE 
echo "Tatin test suite failed"   
FI