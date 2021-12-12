# Runtime Fabric Secure Property from AWS SSM (Parameter Store)

## Introduction

Managing and accessing sensitive information using the MuleSoft application deployed to Runtime Fabric(RTF) can be handled using rtfctl utility. Secure properties are added in the Runtime Fabric cluster locally, are stored securely, and are scoped per environment. Secure properties are accessible in unencrypted form by Mule applications deployed in the scoped environment as custom properties. 
Parameter Store is a capability of AWS Systems Manager which provides secure, hierarchical storage for configuration data management and secrets management. You can store data such as passwords, database strings, and license codes as parameter values. You can store values as plain text or encrypted data. 
If you are storing sensitive data in the Parameter Store which needs to be accessed by MuleSoft application then you need to sync data from Parameter Store to RTF secure property. This utility allows you to sync data between Parameter Store and rtfctl secure property. 

## Prerequisite
### Packages 
To run provided scripts install below packages - 
- AWS CLI
- JQ
- YQ
- RTFCTL

```
$ chmod 755 install-packages.sh
$ ./install-packages.sh
```
install-packages script checks if the above packages are installed and installs them if they are not installed.

Note - install-packages.sh has been tested on RHEL 7. Make changes to the script based on your operating system.

### Permissions
To access Parameter Store using AWS CLI you need to have the right IAM role permissions.

Go to AWS -> IAM and create a policy "ssm-param-store-account-policy" with below permissions - 
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": [
                "arn:aws:kms:*:*:alias/aws/ssm",
                "arn:aws:ssm:*:*:parameter/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "ssm:DescribeParameters",
            "Resource": "*"
        }
    ]
}
```
Create a role in IAM and call it "ssm-account-role". Add "ssm-param-store-account-policy" policy to the role.
Edit the trust relationship of the role to add user 
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::xxxxxx:user/xxxxx"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```
Note - Although the script provided uses assumed role you can also use instance role to provide above permission to ec2 instance from which the script needs to executed

## Read parameters from AWS Parameter Store and add them to rtfctl secure properties
The script reads AWS SSM parameters from a yaml file(parameter-list.yaml) with below format 
```
params:
  - /aj/test/anypoint-user
  - /aj/test/anypoint-pass
```
It uses assumed role to obtain permission to read secure data from AWS Parameter Store.

To run the script - 
```
$ chmod 755 add-props-from-SSM.sh
$ ./add-props-from-SSM.sh <environment_id>
```
<environment_id>: the Anypoint environment ID to scope secure property to. Only applications deployed to this environment will have access to this secure property.

## Read secure properties from backup file and add them to rtfctl secure properties
The script reads key value pairs from a text file(secure-props.txt) with below format 
```
KEY                VALUE
test.key1          value1
test.key2          value2
test.key3          value3
```
To create the backup file execute below command - 
```
$ sudo ./rtfctl get secure-properties -n <environment_id> >> secure-props.txt
```
<environment_id>: the Anypoint environment ID to list the secure properties under.
To run the script - 
```
$ chmod 755 add-props-from-backup.sh
$ ./add-props-from-backup.sh <environment_id>
```

## Read secure properties from property file and add them to rtfctl secure properties
The script reads key value pairs from a property file(test.properties) with below format. 
It also prints the key value pairs added using rtfctl secure properties.
```
test.key1=value1
test.key2=value2
test.key3=value3
```
To run the script - 
```
$ chmod 755 add-props-from-file.sh
$ ./add-props-from-file.sh <environment_id>
```

## Delete all secure properties from rtfctl secure properties
There is no option currently present in rtfctl utility to delete all secure properties.
This script allows you to take a backup of existing secure properties and delete them.

To run the script - 
```
$ chmod 755 delete-secure-props.sh
$ ./delete-secure-props.sh <environment_id>
```

