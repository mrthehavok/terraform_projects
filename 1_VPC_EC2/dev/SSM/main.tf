provider "aws" {}


terraform {
  backend "s3" {
    bucket  =   "mrthehavok.test.cli"
    key     =   "VPC_EC2/dev/vpc/public/terraform.tfstate"
    region  =   "eu-central-1"
  }
}
#------------------------------------------------------------------------------------------------

// Generate Password
resource "random_string" "rds_password" {
  length           = 18
  special          = true
  override_special = "!#$&"
}

// Store Password in SSM Parameter Store
resource "aws_ssm_parameter" "rds_password" {
  name        = "/dev/PostgreSQL"
  description = "Master Password for RDS PostgreSQL"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

// Get Password from SSM Parameter Store
data "aws_ssm_parameter" "my_rds_password" {
  name       = "/dev/PostgreSQL"
  depends_on = [aws_ssm_parameter.rds_password]
}