# AWS Security Hardening using Terraform

## Pre-requisites
- An AWS account with valid credentials (access keys)
- Terraform v1.0.2 or later
- Python v3.6 or later
- Boto3 v.1.17 or later
- A Unix or Bash terminal 

```bash
export AWS_ACCESS_KEY_ID="your_aws_key_id"
export AWS_SECRET_ACCESS_KEY="your_aws_key"
```
## General Requirements (inc. Notes):
- Infrastructure should build as a single `terraform apply`
- Use only Python and Terraform
    - currently need to use Bash for imports (see `imports.sh`)
    - going to use `subprocess.run()` in python as a cheeky loophole. Can combine this with `boto3` to get `vpc_ids` and other variables. 
- Deployment guide to explain pre-requisites and how to run the code 