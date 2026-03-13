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

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web_server.id
}

output "ec2_instance_public_ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.web_server.public_ip
}
