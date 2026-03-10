data "aws_caller_identity" "current" {}

# Example resource - uncomment to create VPC
# resource "aws_vpc" "main" {
#   count      = 0
#   cidr_block = var.vpc_cidr
#   
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   
#   tags = {
#     Name = "${var.environment}-vpc"
#   }
# }
