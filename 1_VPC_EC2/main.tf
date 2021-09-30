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