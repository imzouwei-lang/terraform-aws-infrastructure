data "aws_caller_identity" "current" {}

# Test resource - S3 bucket
resource "aws_s3_bucket" "test" {
  bucket = "terraform-test-${data.aws_caller_identity.current.account_id}"
  
  tags = {
    Name        = "Terraform Test Bucket"
    Environment = var.environment
  }
}
