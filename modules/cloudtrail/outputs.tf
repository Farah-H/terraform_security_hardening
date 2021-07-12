output "logs_bucket" {
    value = aws_s3_bucket.cloudtrail_logs.id
}

output "cloudtrail_policy" {
    value = aws_cloudtrail.cloudtrail_logging.id
}