provider "aws" {
  region = local.region_name
}

terraform {
  backend "s3" {
    bucket  =   "mrthehavok.test.cli"
    key     =   "VPC_EC2/dev/IAM/terraform.tfstate"
    region  =   "eu-central-1"
  }
}

locals {
  company_name  = data.terraform_remote_state.global.outputs.company_name
  region_name   = data.terraform_remote_state.global.outputs.region_name
  common_tags   = data.terraform_remote_state.global.outputs.common_tags
  environment   = data.terraform_remote_state.global.outputs.env
}


#------------------------------------------------------------------------------------------------

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

resource "aws_iam_group" "administrators" {
  name = "administrators"
  path = "/users/"
}