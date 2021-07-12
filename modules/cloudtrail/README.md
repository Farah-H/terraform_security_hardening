# Requirements:
- Enable CloudTrail in all regions
- Enable CloudTrail log validation
- All management and global events are captured within CloudTrail
- Store CloudTrail logs are stored in a private s3 bucket
- Access to the above bucket should also be logged by CloudTrail
- Integrate CloudTrail with CloudWatch Logs
- Ensure CloudTrail logs are encrypted at rest using KMS customer managed keys (CMKs)
- Enable CloudTrail log file integrity validation

# Notes:
- Create s3 private bucket 
- logging to own bucket doesn't work, can create another bucket to save logs to and add those logs to the cloudtrail bucket? 
- created kms cmk in the console, which can be imported into our config and used to encrypt/decrypt logs. 
- bucket permissions may cause issues later, `private` vs `log-delivery-write`
    - private = owner has FULL_CONTROL permissions
    - log-delivery-write = LogDelivery group gets WRITE and READ_ACP permissions
        - https://blog.runpanther.io/s3-bucket-security/
        - based on this^ it seems like log-delivery-write is secure enough
- as per gov.uk website, companies must keep records for 6 years from the end of the financial year they relate to, following the same rules to keep logs for 6 years after creation.  `days = 2190`
    - need to confirm that this is 6 years after input not 6 years after bucket creation
