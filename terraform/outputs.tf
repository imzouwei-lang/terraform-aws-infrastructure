output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "test_bucket_name" {
  description = "Test S3 Bucket Name"
  value       = aws_s3_bucket.test.id
}

output "test_bucket_arn" {
  description = "Test S3 Bucket ARN"
  value       = aws_s3_bucket.test.arn
}
