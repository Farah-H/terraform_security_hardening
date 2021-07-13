import os
import subprocess
import boto3 
import json

aws_regions = [
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2",
    "af-south-1",
    "ap-east-1",
    "ap-south-1",
    "ap-northeast-3",
    "ap-northeast-2",
    "ap-southeast-1",
    "ap-southeast-2",
    "ap-northeast-1",
    "ca-central-1",
    "eu-central-1",
    "eu-west-1",
    "eu-west-2",
    "eu-south-1",
    "eu-west-3",
    "eu-north-1",
    "me-south-1",
    "sa-east-1",
]

# I was having some bugs with credentials, it seems defining these explicitly here helps? 
ACCESS_KEY = os.environ["AWS_ACCESS_KEY_ID"]
SECRET_KEY = os.environ["AWS_SECRET_ACCESS_KEY"]

for region in aws_regions:
    os.environ["AWS_DEFAULT_REGION"] = region

    ec2 = boto3.client('ec2')

    # print and store default vpc id
    vpcs = ec2.describe_vpcs()
    for vpc in vpcs['Vpcs']:
        if vpc["IsDefault"]:
            vpc_id = vpc["VpcId"]
            print(vpc_id)

    # print and store default subnets
    subnets = ec2.describe_subnets()
    subnet_ids = []    
    for subnet in subnets["Subnets"]:
        if subnet["VpcId"] == vpc_id:
            subnet_id = subnet["SubnetId"]
            subnet_ids.append(subnet_id)
            print(subnet_id)
    
    # print and store default igw
    igw = ec2.describe_internet_gateways()
    for gateway in igw["InternetGateways"]:
        if gateway['Attachments'][0]["VpcId"] == vpc_id:
            igw_id = gateway["InternetGatewayId"]
            print(igw_id)
    
    # now we will use bash in python to carry out the terraform commands 
    # first imports: 
    