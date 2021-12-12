#!/bin/bash

env_id=$1

IP=`cat test.properties`

while IFS='=' read -r key value; do
    echo "adding.. key == $key :: value == $value"
    sudo ./rtfctl apply secure-property --key $key --value $value -n $env_id
done <<< "$IP"

getProp=$(sudo ./rtfctl get secure-properties -n $env_id)
echo "All secure properties :: "
echo "$getProp"