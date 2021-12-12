#!/bin/bash

the_role=$(aws sts assume-role --role-arn arn:aws:iam::xxxx:role/ssm-account-role --role-session-name tools-param-store)
export AWS_SESSION_TOKEN=$(echo $the_role | jq .Credentials.SessionToken | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo $the_role | jq .Credentials.SecretAccessKey | xargs)
export AWS_ACCESS_KEY_ID=$(echo $the_role | jq .Credentials.AccessKeyId | xargs)

while IFS= read -r key; do
    #echo "$key"
    value=$(aws ssm get-parameter \
    --name "$key" \
    --with-decryption \
    --region "us-east-2" \
    --query 'Parameter.Value' \
    --output text)
    key=${key##*/} #Retrieve the last part of ssm parameter as key for secure properties
    echo "adding.. key :: $key, value :: $value"
    ./rtfctl apply secure-property --key $key --value $value -n $env_id
done < <(yq eval '.params[]' "parameter-list.yaml")

unset  AWS_SESSION_TOKEN
unset  AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY