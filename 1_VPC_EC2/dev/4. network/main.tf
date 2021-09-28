#------------------------------------------------------------------------------------------------
#
#                                       Create VPC and subnets
#
#------------------------------------------------------------------------------------------------

provider "aws" {
  region = local.region_name
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
  company_name  = data.terraform_remote_state.global.outputs.company_name
  region_name   = data.terraform_remote_state.global.outputs.region_name
  common_tags   = data.terraform_remote_state.global.outputs.common_tags
  environment   = data.terraform_remote_state.global.outputs.env
}

#------------------------------------------------------------------------------------------------
#                                         VPC
#------------------------------------------------------------------------------------------------

//  All info about module you can find in https://github.com/terraform-aws-modules/terraform-aws-vpc
module "vpc_dev" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.environment}-vpc-for-${local.company_name}"
  cidr = var.cidr_block

  azs               = var.azs
  private_subnets   = var.private_subnets
  public_subnets    = var.public_subnets
  database_subnets  = var.database_subnets
  create_database_subnet_group = false
  create_database_subnet_route_table     = true
#  create_database_internet_gateway_route = true

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = local.common_tags
}