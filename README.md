# AWS Security Hardening using Terraform
This repository contains a terraform and python script that, when run against an existing AWS account:
1. Deletes the default VPC and associated infrastructure
2. Creates a private s3 bucket to contain CloudTrail logs
3. Creates a CloudTrail to track all global and management events, including access to the above bucket. 
4. In every region. 

Please refer to the README.mds in the `modules` directories for more details / context / notes and specifically which requirements were met and how this was done. 

## Pre-requisites
- An AWS account:
    -  with valid credentials (access keys) and permissions to perform global actions
    - All regions enabled (this can be checked using the AWS console in account settings)
- [Terraform v1.0.2](https://www.terraform.io/downloads.html) or later
- [Python v3.6](https://www.python.org/downloads/) or later
- Boto3 v.1.17 or later
    - if `pip install boto3` doesn't work or you get a 'no module called boto3' error try: 
        ```bash
        python3 -m pip install --user boto3
        ```
- A Unix or Bash terminal, you will have this by default on a mac or linux machine. If you are using windows you can [download bash here](https://itsfoss.com/install-bash-on-windows/).


## How to run this code:
1. Ensure that your AWS credentials, specifically your access keys, are stored as environment variables. You can [use a `venv`](https://docs.python.org/3/library/venv.html) for this if you like. 

    ```bash
    export AWS_ACCESS_KEY_ID="your_aws_key_id"
    export AWS_SECRET_ACCESS_KEY="your_aws_key"
    ```
2. a) **If you want to create this infrastructure in every aws region.** In the `terraform_security_hardening` directory, run the following command on your unix terminal:
    ```bash
    python3 main.py
    ```
    It is important that you run this in a seperate terminal, not the one in your IDE, because sometimes it returns a 'boto3 module not found' error, if you have the wrong interpreter selected. 

    b) **if you only want to apply this configuration to one region** First you must edit the `modules/default_vpc/imports.sh` file to include your selected region and vpc/subnet/igw_ids. These can be found in the AWS console or you can use the following snippet from the `main.py` script to print out these values:
    
    ```python
    import boto3
    os.environ["AWS_DEFAULT_REGION"] = region

    ec2 = boto3.client('ec2')

    vpcs = ec2.describe_vpcs()
    vpc_id = ""
    for vpc in vpcs['Vpcs']:
        if vpc["IsDefault"]:
            vpc_id = vpc["VpcId"]
            print(vpc_id)

    # checking that there is a vpc 
    if len(vpc_id) > 1:
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
    ```
    After you edit the `imports.sh` file, run the following commands in your unix terminal:

    ```bash
    bash modules/default_vpc/imports.sh
    ```

    Feel free to remove the `auto-approve` flag if you want to confirm and approve the changes before applying. This will require a `yes` input from you. It is not recommended that you do this for the all-regions script, as it will be cumbersome. 

## General Requirements (inc. Notes):
- Infrastructure should build as a single `terraform apply` (done - i'm assuming imports don't count)
- Use only Python and Terraform
    - currently need to use Bash for imports (see `imports.sh`)
    - used `subprocess.run()` in python as a cheeky loophole.
- Deployment guide to explain pre-requisites and how to run the code (done)