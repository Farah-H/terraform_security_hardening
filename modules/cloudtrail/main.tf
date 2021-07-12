# for now we are importing an existing key 
# this key enables encrption/decryption of logs
resource "aws_kms_key" "bucket_key" {
    description = "key for cloudtrail logs bucket"

    # policy here, by default key has all permissions if a policy is not defined 
    # a policy was already defined when I created the key in console.
}

resource "aws_s3_bucket" "cloudtrail_logs" {
    bucket = "cloudtrail_logs"
    acl = "log-delivery-write" 

    logging {
        # logging to own bucket doesn't work
        target_bucket = aws_s3_bucket.cloudtrail_bucket_logs.id
    }

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

    expiration {
        days = 2190
    }
}

# there is probably a better way to do this 
# this bucket exists so that cloudtrail bucket logs can be sent here
# the plan is to route these logs back into the cloudtrail bucket somehow
resource "aws_s3_bucket" "cloudtrail_bucket_logs" {
    bucket = "cloudtrail_bucket_logs"
    acl = "log-delivery-write"
    logging {
        target_bucket = aws_s3_bucket.cloudtrail_logs.id
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = aws_kms_key.bucket_key.arn
                sse_algorithm = "aws:kms"
            }
        }
    }

    versioning {
        enabled = true 
    }

    expiration {
        days = 2190
    }
}

resource "aws_cloudtrail" "cloudtrail_logging" {
    name = "cloudtrail_logging" 
    s3_bucket_name = aws_s3_bucket.cloudtrail_logs.id
    include_global_service_events = true
    enable_log_file_validation = true 
    is_multi_region_trail = true 
    is_organisation_trail = true
    kms_key_id = aws_kms_key.bucket_key.arn


    # events to track 
    event_selector {
        include_management_events = true 
    }

}