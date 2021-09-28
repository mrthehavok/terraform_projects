provider "aws" {}




terraform {
  backend "s3" {
    bucket  =   "mrthehavok.test.cli"
    key     =   "VPC_EC2/dev/RDS/terraform.tfstate"
    region  =   "eu-central-1"
  }
}

#------------------------------------------------------------------------------------------------

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "mrthehavok.test.cli"
    key    = "VPC_EC2/globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "SSM" {
  backend = "s3"
  config = {
    bucket = "mrthehavok.test.cli"
    key    = "VPC_EC2/dev/SSM/terraform.tfstate"
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

#------------------------------------------------------------------------------------------------

locals {
  company_name      = data.terraform_remote_state.global.outputs.company_name
  region_name       = data.terraform_remote_state.global.outputs.region_name
  common_tags       = data.terraform_remote_state.global.outputs.common_tags
  environment       = data.terraform_remote_state.global.outputs.env
  ssm_password      = data.terraform_remote_state.SSM.outputs.rds_password
  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  db_subnet_id      = data.terraform_remote_state.network.outputs.db_subnet_id
  vpc_cidr_block    = data.terraform_remote_state.network.outputs.vpc_cidr_block
}


#------------------------------------------------------------------------------------------------

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = " ${local.environment}-DB-SG"
  description = " PostgreSQL  security group"
  vpc_id      = local.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = local.vpc_cidr_block
    },
  ]

  tags = local.common_tags
}



#------------------------------------------------------------------------------------------------

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

#  identifier = "${local.environment}-DB"
  identifier = "dev-db"
  engine               = "postgres"
  engine_version       = "11.10"
  family               = "postgres11" # DB parameter group
  major_engine_version = "11"         # DB option group
  instance_class       = "db.t2.micro"

  allocated_storage     = 5
  max_allocated_storage = 20
  storage_encrypted     = false

  name     = "${local.environment}_PostgreSQL"
  username = "root"
  password = local.ssm_password
  port     = "5432"

  iam_database_authentication_enabled = true


  multi_az               = false
  subnet_ids             = local.db_subnet_id
  vpc_security_group_ids = [module.security_group.security_group_id]


  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"


  tags = local.common_tags

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]
  # Disable creation of option group - provide an option group or default AWS default
  create_db_option_group = false

  # Disable creation of parameter group - provide a parameter group or default to AWS default
  create_db_parameter_group = false

  # Disable creation of subnet group - provide a subnet group
  create_db_subnet_group = true

  # Disable creation of monitoring IAM role
  create_monitoring_role = false

}

