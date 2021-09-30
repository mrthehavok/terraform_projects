provider "aws" {
#  region    =   var.region_name
}

terraform {
  backend "s3" {
    bucket = "mrthehavok.test.cli"
    key    = "Alpha/terraform.tfstate"
    region = "eu-central-1"
  }
}



module "IAM" {
  source          = "./modules/2_IAM"
}


module "SSM" {
  source = "./modules/3_SSM"
  common_tags = var.common_tags
  environment = var.environment
}

/*
module "network" {
  source = "./modules/4_network"
}

module "blue_green" {
  source = "./modules/5_VPC/public"
}

module "RDS" {
  source = "./modules/6_RDS"
}

*/