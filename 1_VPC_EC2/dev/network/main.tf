#------------------------------------------------------------------------------------------------
#
#       Create VPC and subnets
#
#------------------------------------------------------------------------------------------------

provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket  =   "mrthehavok.test.cli"
    key     =   "VPC_EC2/dev/network/terraform.tfstate"
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


module "vpc_dev" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.company_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = local.common_tags
}