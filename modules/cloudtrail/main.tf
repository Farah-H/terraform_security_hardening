data "aws_caller_identity" "current" {}


# for now we are importing an existing key 
# this key enables encrption/decryption of logs
resource "aws_kms_key" "bucket_key" {
    description = "key for cloudtrail logs bucket"

    # policy here, by default key has all permissions if a policy is not defined 
    # a policy was already defined when I created the key in console.
}

resource "aws_s3_bucket" "cloudtrail_logs" {
    bucket = "cloudtrail-logs-1"
    acl = "log-delivery-write" 

    #hoping this will fix naming bugs
    force_destroy = true

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = aws_kms_key.bucket_key.arn
                sse_algorithm = "aws:kms"
            }
        }
    }

    # versioning ensures that when the bucket recieves multiple requests at the same time
    # it stores all of them, this makes sense to enable for logging
    versioning {
        enabled = true
    }

    # copying this from documantation in the hope that it fixes some bugs
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::cloudtrail-logs-1"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::cloudtrail-logs-1/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
        }
    ]
}
POLICY
}


# data "aws_s3_bucket" "cloudtrail_logs"  {
#     bucket = aws_s3_bucket.cloudtrail_logs.id
# }

# resource "aws_cloudtrail" "cloudtrail_logging" {
#     name = "cloudtrail_logging" 
#     s3_bucket_name = aws_s3_bucket.cloudtrail_logs.id
#     s3_key_prefix = ""

#     include_global_service_events = true
#     enable_log_file_validation = true 
    
#     # commenting this out, might fix some bugs
#     #is_multi_region_trail = true 

#     # testing on personal account, so commenting this out
#     # is_organization_trail = true
#     kms_key_id = aws_kms_key.bucket_key.arn
 

#     # track cloudtrail-logs bucket
#     event_selector {
#         include_management_events = true 
#         read_write_type = "All"

#         data_resource {
#             type = "AWS::S3::cloudtrail-logs*"
#             values = ["${data.aws_s3_bucket.cloudtrail_logs.arn}/"]
#         }
#     }

#     # link to cloudwatch here 

# }