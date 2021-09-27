#------------------------------------------------------------------------------------------------
#
#                                  Global variables for my project
#
#------------------------------------------------------------------------------------------------

provider "aws" {}

terraform {
  backend "s3" {
    bucket = "mrthehavok.test.cli"
    key    = "VPC_EC2/globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

#------------------------------------------------------------------------------------------------

output "Project" {
  value = "VPC_EC2"
}

output "company_name" {
  value = "CMP inc"
}

output "env" {
  value = "DEV"
}

output "common_tags" {
  value = {
      Project     = "VPC_EC2"
      Created     = "By Terraform"
      Owner       = "idmitriev"
      Environment = "Development"
  }
}

output "region_name" {
  value = "eu-west-1"
}