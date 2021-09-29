provider "aws" {
  region    =   var.region_name
}




module "global_vars" {
  source = "./modules/1_globalvars"
}

module "IAM" {
  source = "./modules/2_IAM"
}

/*
module "SSM" {
  source = "./modules/3_SSM"
}


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