data "aws_caller_identity" "current" {}

# Test resource - S3 bucket
resource "aws_s3_bucket" "test" {
  bucket = "terraform-test-${data.aws_caller_identity.current.account_id}"
  
  tags = {
    Name        = "Terraform Test Bucket"
    Environment = var.environment
  }
}

# New S3 bucket for data storage
resource "aws_s3_bucket" "data_storage" {
  bucket = "data-storage-${data.aws_caller_identity.current.account_id}"
  
  tags = {
    Name        = "Data Storage Bucket"
    Environment = var.environment
    Purpose     = "Data Storage"
  }
}
