provider "aws" {
  region = var.region_name
}


terraform {
  backend "s3" {
    bucket = "mrthehavok.test.cli"
    key    = "Alpha/terraform.tfstate"
    region = "eu-central-1"
  }
}


locals {
  public_subnets  = module.vpc.public_subnets
  identifier      = lower("${var.environment}-${var.engine}-db")
}

module "IAM" {
  source          = "./modules/IAM"
}

module "SSM" {
  source          = "./modules/SSM"
  common_tags     = var.common_tags
  environment     = var.environment
}

module "vpc" {
  source          = "./modules/network"
  cidr_block =      var.cidr_block
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  database_subnets= var.database_subnets 
  common_tags     = var.common_tags
  environment     = var.environment
}


/*
module "ec2" {
  source          = "./modules/VPC/public"
  des_asg_size  = var.des_asg_size
  max_asg_size  = var.max_asg_size
  min_asg_size  = var.min_asg_size
  subnet_id     = [local.public_subnets]
  vpc_id        = module.vpc.vpc_id
  common_tags   = var.common_tags
  key_name      = var.key_name
}
*/


module "RDS" {
  source          = "./modules/RDS"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.database_subnets
  common_tags     = var.common_tags
  ssm_password    = module.SSM.rds_password
  identifier      = local.identifier
}
