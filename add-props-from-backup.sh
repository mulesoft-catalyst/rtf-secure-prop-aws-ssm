#!/bin/bash

echo "Secure properties"
env_id=$1

IP=`cat secure-props.txt`
#echo "$IP"
counter=0
while IFS=' ' read -r key value; do
    if [[ $counter -gt 0 ]]
    then
        echo "adding.. key == $key :: value == $value"
        sudo ./rtfctl apply secure-property --key $key --value $value -n $env_id
    else
        counter=1
    fi
done <<< "$IP"