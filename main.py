import os
import subprocess
import boto3 
# access keys are automatically sourced from env

aws_regions = boto3.ec2.regions()

ACCESS_KEY = os.environ["AWS_ACCESS_KEY_ID"]
SECRET_KEY = os.environ["AWS_SECRET_ACCESS_KEY"]

for region in aws_regions:
    ec2 = boto3.connect_ec2(ACCESS_KEY, SECRET_KEY, region=region)

    # print a list of vpc ids for that region 
    vpcs = ec2.describe_vpcs()
    for vpc in vpcs['Vpcs']:
        print(vpc["VpcId"])

    # print a list of subnet ids for that region
    subnets = ec2.describe_subnets()
    for subnet in subnets["Subnets"]:
        print(subnet["SubnetId"])
