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

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.medium"
  subnet_id              = "subnet-0edc9c21510e8e9fe"
  vpc_security_group_ids = ["sg-0186c9147e25512ff"]
  key_name               = "6877-ues-east-1"

  tags = {
    Name = "terraform-ec2-instance"
  }
}
# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.medium"
  subnet_id              = "subnet-0edc9c21510e8e9fe"
  vpc_security_group_ids = ["sg-0186c9147e25512ff"]
  key_name               = "6877-ues-east-1"

  tags = {
    Name = "terraform-ec2-instance"
  }
}
