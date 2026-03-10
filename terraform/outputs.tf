output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.main[0].id, null)
}

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}
