#------------------------------------------------------------------------------------------------
#
#                             Output for root module
#
#------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------
#                                         Users
#------------------------------------------------------------------------------------------------

output "ARN_super" {
  value = module.IAM.ARN_super
}

output "ARN_DB" {
  value = module.IAM.ARN_DB
}

output "ARN_dev1" {
  value = module.IAM.ARN_dev1
}

output "ARN_dev2" {
  value = module.IAM.ARN_dev2
}

#------------------------------------------------------------------------------------------------
#                                         SSM
#------------------------------------------------------------------------------------------------



output "rds_password" {
  value = module.SSM.rds_password
  sensitive = true
}

#------------------------------------------------------------------------------------------------
#                                         Network
#------------------------------------------------------------------------------------------------


output "vpc_id" {
  value = module.vpc.vpc_id	
}


output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block	
}


output "public_subnets" {
  value = module.vpc.public_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets	
}

#------------------------------------------------------------------------------------------------
#                                         RDS
#------------------------------------------------------------------------------------------------

output "db_instance_address" {
  value = module.RDS.db_instance_address		
}


output "db_instance_port" {
  value = module.RDS.db_instance_port		
}


output "db_instance_name" {
  value = module.RDS.db_instance_name		
}