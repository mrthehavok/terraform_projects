provider "aws" {
  region = local.region_name
}

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

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "mrthehavok.test.cli"
    key    = "VPC_EC2/dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  company_name  = data.terraform_remote_state.global.outputs.company_name
  region_name   = data.terraform_remote_state.global.outputs.region_name
  common_tags   = data.terraform_remote_state.global.outputs.common_tags
  subnets       = data.terraform_remote_state.network.outputs.subnet_id
  vpc_id        = data.terraform_remote_state.network.outputs.vpc_id
}

#------------------------------------------------------------------------------------------------


module "asg_web" {
  source = "github.com/mrthehavok/terraform_modules/modules/aws_ec2_asg/"
  des_asg_size  = 1
  max_asg_size  = 4
  subnet_id     = local.subnets
  vpc_id        = local.vpc_id
#  common_tags = local.common_tags
}

