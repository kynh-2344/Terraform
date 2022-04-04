output "web_static_domain_name" {
    value = aws_s3_bucket.app_bucket.*.bucket_domain_name
}

output "bucket_arns" {
    value = aws_s3_bucket.app_bucket.*.arn
}