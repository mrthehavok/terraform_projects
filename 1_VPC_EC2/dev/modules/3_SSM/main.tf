#------------------------------------------------------------------------------------------------
#
#                                       Create password for RDS
#
#------------------------------------------------------------------------------------------------
/*
terraform {
  backend "s3" {
    bucket  =   var.bucket_name
    key     =   "${var.project_name}/dev/SSM/terraform.tfstate"
    region  =   var.bucket_region
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "${var.project_name}/globalvars/terraform.tfstate"
    region = var.bucket_region
  }
}



locals {
  company_name  = data.terraform_remote_state.global.outputs.company_name
  region_name   = data.terraform_remote_state.global.outputs.region_name
  common_tags   = data.terraform_remote_state.global.outputs.common_tags
  environment   = data.terraform_remote_state.global.outputs.env
}
*/
#------------------------------------------------------------------------------------------------

// Generate Password
resource "random_string" "rds_password" {
  length           = 18
  special          = true
  override_special = "!#$&"
}

// Store Password in SSM Parameter Store
resource "aws_ssm_parameter" "rds_password" {
  name        = "/${var.environment}/RDS"
  description = "Master Password for RDS "
  type        = "SecureString"
  value       = random_string.rds_password.result
  tags        = var.common_tags
}


// Get Password from SSM Parameter Store
data "aws_ssm_parameter" "my_rds_password" {
  name       = "/${var.environment}/RDS"
  depends_on = [aws_ssm_parameter.rds_password]
}
