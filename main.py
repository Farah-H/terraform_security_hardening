import os
import subprocess
import boto3


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
    vpc_id = ""
    for vpc in vpcs['Vpcs']:
        if vpc["IsDefault"]:
            vpc_id = vpc["VpcId"]
            print(vpc_id)

    # checking that there is a vpc 
    if len(vpc_id) > 1:
        # if there is a default vpc, then run the imports to load existing infrastructure
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

        # Using Shell in Python to use Terraform commands 
        # defining provider region
        os.environ["TF_VAR_region"]=region

        # importing vpc
        subprocess.run(f"terraform import module.delete_default_vpc.aws_vpc.default {vpc_id}", shell=True)

        # importing subnets
        for i in range(len(subnet_ids)):
            subprocess.run(f"terraform import module.delete_default_vpc.aws_subnet.default_{i} {subnet_ids[i]}", shell=True)

        # importing igw
        subprocess.run(f"terraform import module.delete_default_vpc.aws_internet_gateway.default {igw_id}", shell=True)
    else: 
        print(f"There is no default VPC in {region}.")

    # applying configuration to that region
    subprocess.run("terraform apply -auto-approve", shell=True)

    # after configuring every region we need to remove the state from terraform 
    # using 'state rm' as opposed to 'terraform destroy' preserves the architecture
    state = [
        "module.cloudtrail_logging.data.aws_caller_identity.current",
        "module.cloudtrail_logging.data.aws_s3_bucket.cloudtrail_logs",
        "module.cloudtrail_logging.aws_cloudtrail.cloudtrail_logging",
        "module.cloudtrail_logging.aws_kms_key.bucket_key",
        "module.cloudtrail_logging.aws_s3_bucket.cloudtrail_logs",
        "module.cloudtrail_logging.aws_s3_bucket_policy.cloudtrail_logs_bucket_policy",

    ]
    for item in state:
        subprocess.run(f"terraform state rm {item}", shell=True)