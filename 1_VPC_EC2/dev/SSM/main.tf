provider "aws" {}


terraform {
  backend "s3" {
    bucket  =   "mrthehavok.test.cli"
    key     =   "VPC_EC2/dev/SSM/terraform.tfstate"
    region  =   "eu-central-1"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "mrthehavok.test.cli"
    key    = "VPC_EC2/globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  company_name  = data.terraform_remote_state.global.outputs.company_name
  region_name   = data.terraform_remote_state.global.outputs.region_name
  common_tags   = data.terraform_remote_state.global.outputs.common_tags
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
  tags        = local.common_tags
}


// Get Password from SSM Parameter Store
data "aws_ssm_parameter" "my_rds_password" {
  name       = "/dev/PostgreSQL"
  depends_on = [aws_ssm_parameter.rds_password]
}
