!#/bin/bash

# This finds Default Security Groups of all AWS regions that have Outbound rule with CIDR 0.0.0.0/0

for region in `aws ec2 describe-regions --query "Regions[*].RegionName" --output text`
do
echo "Region $region"

    echo "<===== $region ======>" 
    echo "Outbound Rule "
    defaultSGid=$( aws ec2 describe-security-groups --filters Name=egress.ip-permission.cidr,Values='0.0.0.0/0' --query "SecurityGroups[?GroupName=='default'].GroupId" --region $region --output text)
    if [ -z "$defaultSGid" ] 
    then
        echo "Nothing with 0.0.0.0/0"; exit 1;
    else
        echo "Removing Outbond Rule : Port - ALL Protocol - ALL CIDR - 0.0.0.0/0 for Default SG $defaultSGid"
        aws ec2 revoke-security-group-egress --group-id $defaultSGid --protocol all --port all --cidr '0.0.0.0/0' --region $region
    fi
done
