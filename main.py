import os
import subprocess
import boto3 
# access keys are automatically sourced from env
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

ACCESS_KEY = os.environ["AWS_ACCESS_KEY_ID"]
SECRET_KEY = os.environ["AWS_SECRET_ACCESS_KEY"]

for region in aws_regions:
    ec2 = boto3.client('ec2')

    # print a list of vpc ids for that region 
    vpcs = ec2.describe_vpcs()
    for vpc in vpcs['Vpcs']:
        print(vpc["VpcId"])
        print(vpc)

    # print a list of subnet ids for that region
    subnets = ec2.describe_subnets()
    for subnet in subnets["Subnets"]:
        print(subnet["SubnetId"])
