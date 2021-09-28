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


/*
#------------------------------------------------------------------------------------------------

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "${locals.environment}_DB"

  engine               = "postgres"
  engine_version       = "11.10"
  family               = "postgres11" # DB parameter group
  major_engine_version = "11"         # DB option group
  instance_class       = "db.t2.micro"

  allocated_storage     = 5
  max_allocated_storage = 20
  storage_encrypted     = false

  name     = "${locals.environment}-PostgreSQL"
  username = "pg_root"
  password = locals.ssm_password
  port     = "5432"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["sg-12345678"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = true

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

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

*/