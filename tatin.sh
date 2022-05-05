#!/bin/bash

# Was used to fire up a Tatin server before we went "Docker"

DYALOGDIR=/opt/mdyalog/18.2/64/unicode/

RIDEPORT=0
ARGS=""

export MAXWS=1G
export DYALOG_NETCORE=1

Usage ()
{
        echo "Usage: $0 [-p ride_port] <args for apl>"
        exit 1
}

while [ $# -ne 0 ]
do
        case $1 in
                -p)     [ $# -le 1 ] && Usage
                        shift ; RIDEPORT=$1
                        ;;
                *)      ARGS="$ARGS $1"
                        ;;
        esac
        shift
done

if [ $RIDEPORT -ne 0 ]          # Use zero to unset the RIDE_INIT variable
then
        export RIDE_INIT="SERVE:*:$RIDEPORT"
        if [ 0 -ne `netstat -an | grep -c $RIDEPORT` ]
        then
                echo "Port $RIDEPORT already in use; bailing"
                exit 2
        fi
fi

echo $RIDE_LISTEN dyalog $ARGS
dyalog Server.dws "${ARGS}" +s

