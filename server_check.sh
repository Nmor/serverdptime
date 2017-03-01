#!/bin/bash
NOTIFYEMAIL=random@hngexecutives.mailclark.ai
SMSEMAIL=seun@hotels.ng
SENDEREMAIL=moses@hotels.ng
SERVER=https://154.73.11.107:8812
PAUSE=60
FAILED=0
DEBUG=0

while true 
do
/usr/bin/curl -k -sSf $SERVER > /dev/null 2>&1
CS=$?
# For debugging purposes
if [ $DEBUG -eq 1 ]
then
    echo "STATUS = $CS"
    echo "FAILED = $FAILED"
    if [ $CS -ne 0 ]
    then
        echo "$SERVER is down"

    elif [ $CS -eq 0 ]
    then        
echo "$SERVER is up"
    fi
fi

# If the server is down and no alert is sent - alert
if [ $CS -ne 0 ] && [ $FAILED -eq 0 ]
then
    FAILED=1
    if [ $DEBUG -eq 1 ]
    then
        echo "$SERVER failed"
    fi
    if [ $DEBUG = 0 ]
    then
        echo "@channel Elastix Server $SERVER (Olonade Office) went down $(date)" | mail -s "$SERVER went down" "$SENDEREMAIL" "$SMSEMAIL"
        echo "@channel Elastix Server $SERVER (Olonade Office) went down $(date)" | mail -s "$SERVER went down" "$SENDEREMAIL" "$NOTIFYEMAIL"
    fi

# If the server is back up and no alert is sent - alert
elif [ $CS -eq 0 ] && [ $FAILED -eq 1 ]
then
    FAILED=0
    if [ $DEBUG -eq 1 ]
    then
        echo "$SERVER is back up"
    fi
    if [ $DEBUG = 0 ]
    then
        echo "@channel Elastix Server $SERVER (Olonade Office) is back up $(date)" | mail -s "$SERVER is back up again" "$SENDEREMAIL" "$SMSEMAIL"
        echo "@channel Elastix Server $SERVER (Olonade Office) is back up $(date)" | mail -s "$SERVER is back up again" "$SENDEREMAIL" "$NOTIFYEMAIL"
    fi
fi
sleep $PAUSE
done
