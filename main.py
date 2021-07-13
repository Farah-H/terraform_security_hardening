import os
import subprocess
import boto3 




subprocess.run("pwd")
# this script will loop through regions and 'terraform apply' 
# it will also use boto3 to source vpc / subnet details and feed those vars into a bash script
