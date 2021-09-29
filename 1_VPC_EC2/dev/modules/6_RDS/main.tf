#------------------------------------------------------------------------------------------------
#
#                                       Create security group for RDS and RDS
#
#------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket  =   var.bucket_name
    key     =   "${var.project_name}/dev/RDS/terraform.tfstate"
    region  =   var.bucket_region
  }
}

#------------------------------------------------------------------------------------------------

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "${var.project_name}/globalvars/terraform.tfstate"
    region = var.bucket_region
  }
}

data "terraform_remote_state" "SSM" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "${var.project_name}/dev/SSM/terraform.tfstate"
    region = var.bucket_region
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "${var.project_name}/dev/network/terraform.tfstate"
    region = var.bucket_region
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
#                                         Security Group for RDS
#------------------------------------------------------------------------------------------------
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = " ${local.environment}-DB-SG"
  description = " ${var.engine}  security group"
  vpc_id      = local.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = var.db_port
      to_port     = var.db_port
      protocol    = "tcp"
      description = "${var.engine} access from within VPC"
      cidr_blocks = local.vpc_cidr_block
    },
  ]

  tags = local.common_tags
}



#------------------------------------------------------------------------------------------------
#                                         RDS
#------------------------------------------------------------------------------------------------
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

#  identifier = "${local.environment}-DB"
  identifier = "dev-db"
  engine               = "${var.engine}"
  engine_version       = "11.10"
  family               = "postgres11" # DB parameter group
  major_engine_version = "11"         # DB option group
  instance_class       = "db.t2.micro"

  allocated_storage     = 5
  max_allocated_storage = 20
  storage_encrypted     = false

  name     = "${local.environment}_${var.engine}"
  username = var.db_username
  password = local.ssm_password
  port     = var.db_port

  iam_database_authentication_enabled = true


  multi_az               = false
  subnet_ids             = local.db_subnet_id
  vpc_security_group_ids = [module.security_group.security_group_id]


  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window


  tags = local.common_tags

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "character_set_client"
      value = var.character_set
    },
    {
      name = "character_set_server"
      value = var.character_set
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

