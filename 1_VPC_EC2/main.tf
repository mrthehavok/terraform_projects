provider "aws" {}


terraform {
  backend "s3" {
    bucket = "mrthehavok.test.cli"
    key    = "Alpha/terraform.tfstate"
    region = "eu-central-1"
  }
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
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  database_subnets= var.database_subnets 
  common_tags     = var.common_tags
  environment     = var.environment
}