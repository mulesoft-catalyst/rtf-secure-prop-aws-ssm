#!/bin/bash

env_id=$1
processingDate=$(TZ=GMT date '+%Y%m%dT%H%M%SZ')

sudo ./rtfctl get secure-properties -n $env_id >> secure-props-$processingDate.txt

IP=`cat secure-props-$processingDate.txt`
#echo "$IP"
counter=0
while IFS=' ' read -r key value; do
    if [[ $counter -gt 0 ]]
    then
        echo "deleting.. key == $key ::value == $value"
        ./rtfctl delete secure-property $key -n $env_id
    else
        counter=1
    fi
done <<< "$IP"