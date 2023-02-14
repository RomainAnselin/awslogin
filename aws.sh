#!/bin/bash

usage() {
  if [ $# -ne 0 ]; then
    echo "Usage: $0 [-l] [-s] [-h]"
    echo "  -l   cleanup and logon"
    echo "  -s   set vars"
    echo "  -h   show this help"
    echo exiting... && sleep 10 && exit 1
  fi
}

awslogon() {
	if [ ! -n $awsprofile ]; then
		printf "\nUsing profile %s\n" $awsprofile
	else
		printf "\n!!! IMPORTANT !!!\nProfile not found. Set awsprofile variable or input below\n\n"
		grep profile ~/.aws/config | sed -E 's/\[profile (.*)\]/\1/g'
		printf "\n"
		read -p "Select profile to use: " awsprofile
		printf "\n"
	fi

	for var in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN ; do eval unset $var ; done
	aws sso logout
	aws sso login --profile $awsprofile
	aws sts get-caller-identity --profile $awsprofile
}

awsvars() {
   # local OPTIND=1
   # echo OPTINDaws $OPTIND
	for var in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN ; do eval unset $var ; done
	awscreds=$( ls -t ~/.aws/cli/cache/*.json | head -1 )
	export AWS_ACCESS_KEY_ID=`jq -r ".Credentials.AccessKeyId" $awscreds`
	export AWS_SECRET_ACCESS_KEY=`jq -r ".Credentials.SecretAccessKey" $awscreds`
	export AWS_SESSION_TOKEN=`jq -r ".Credentials.SessionToken" $awscreds`
	echo "Token expiration: " $(jq -r ".Credentials.Expiration" $awscreds)
}

# SUPPORT-1365
# https://stackoverflow.com/questions/42336595/in-bash-why-does-using-getopts-in-a-function-only-work-once
# getopts when called with sourcing will increment the OPTIND variable, making the function not re-usable. As per above link

local OPTIND=1
while getopts "lsh" option; do
  case "${option}" in
    l) echo "AWS Logon"
       awslogon ;;
    s) echo "Setting AWS variables"
       awsvars  ;;
    h) echo "Showing help"
       usage ;;
    *) echo "Showing help"
       usage ;;
    ?) echo "Showing help"
       usage ;;
  esac
done
local OPTIND=1
# echo OPTINDex $OPTIND