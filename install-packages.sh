#!/bin/bash

#This script checks if pre-requisite packages are installed and installs them if they are not installed

isUnzipInstalled=$(which unzip)

if [ -z "$isUnzipInstalled" ]
then
        echo "Installing unzip and zip packages.."
        sudo yum install zip unzip -y
else
        echo "zip unzip package is installed"
        echo "unzip version :: $(unzip -v)"
fi

echo "--------------------------------------------------------------------------------------------------"

isAWSInstalled=$(aws --version)

if [ -z "$isAWSInstalled" ]
then
        echo "Installing AWS CLI.."
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
else

        echo "AWS CLI is installed"
        echo "AWS CLI version:: $(aws --version)"
        echo "AWS location :: $(which aws)"
fi

echo "--------------------------------------------------------------------------------------------------"


isJqInstalled=$(jq --version)

if [ -z "$isJqInstalled" ]
then
        echo "Installing jq.."
        sudo curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/bin/jq && sudo chmod +x /usr/bin/jq
else

        echo "jq is installed"
        echo "jq version :: $(jq --version)"
        echo "jq location :: $(which jq)"
fi

echo "--------------------------------------------------------------------------------------------------"

isYqInstalled=$(yq --version)

if [ -z "$isYqInstalled" ]
then
        echo "Installing yq.."
        sudo curl -L https://github.com/mikefarah/yq/releases/download/v4.16.1/yq_linux_amd64 -o /usr/bin/yq && sudo chmod +x /usr/bin/yq
else
        echo "yq is installed"
        echo "yq version :: $(yq --version)"
        echo "yq location :: $(which yq)"
fi

echo "--------------------------------------------------------------------------------------------------"

isRtfctlInstalled=$(sudo rtfctl version)

if [ -z "$isRtfctlInstalled" ]
then
        echo "Installing rtfctl.."
        sudo curl -L https://anypoint.mulesoft.com/runtimefabric/api/download/rtfctl/latest -o /usr/bin/rtfctl && sudo chmod +x /usr/bin/rtfctl
else
        echo "rtfctl is installed"
        echo "rtfctl version :: $(sudo rtfctl version)"
        echo "rtfctl location :: $(which rtfctl)"
fi

echo "--------------------------------------------------------------------------------------------------"
