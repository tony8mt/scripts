#!/bin/bash

echo "ONLY parameters allowed is Blank, missing and enabled"

if [ "$1" == "missing" ] # list only buckets without access logs
then
	for i in `aws s3 ls | cut -d " " -f3`
	do 
		loggingtrue=`aws s3api get-bucket-logging --bucket $i`
		if [ -z "$loggingtrue" ]; then 
			echo "S3 Bucket $i"
			echo " ---MISSING---"
		fi
	done 
elif [ "$1" == "enabled" ]	# list only buckets with access logs
then
	for i in `aws s3 ls | cut -d " " -f3`
	do 
		loggingtrue=`aws s3api get-bucket-logging --bucket $i`
		if [ "$loggingtrue" ]; then 
			echo "S3 Bucket $i"
			aws s3api get-bucket-logging --bucket $i
		fi
	done 
elif [ -z "$1" ]  #list everything
then
	for i in `aws s3 ls | cut -d " " -f3`
	do 
		echo "S3 Bucket $i"
		loggingtrue=`aws s3api get-bucket-logging --bucket $i`

		if [ -z "$loggingtrue" ]; then 
			echo " ---MISSING---"
		else 
			aws s3api get-bucket-logging --bucket $i
		fi
	done 
else 
	echo "Invalid arguments"
	exit 1
fi


