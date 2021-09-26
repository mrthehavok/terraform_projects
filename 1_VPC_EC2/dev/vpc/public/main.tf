provider "aws" {}

terraform {
  backend "s3" {
    bucket  =   "mrthehavok.test.cli"
    key     =   "VPC_EC2/dev/vpc/public/terraform.tfstate"
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
  company_name = data.terraform_remote_state.global.outputs.company_name
  common_tags  = data.terraform_remote_state.global.outputs.common_tags
}

#------------------------------------------------------------------------------------------------


module "asg_web" {
  source = "../../../modules/aws_ec2_asg/"
#  common_tags = local.common_tags
}