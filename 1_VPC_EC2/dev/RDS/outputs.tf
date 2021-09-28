#------------------------------------------------------------------------------------------------
#
#                                       Outputs for connection string to DB
#
#------------------------------------------------------------------------------------------------

output "db_instance_address" {
  value = module.db.db_instance_address		
}


output "db_instance_port" {
  value = module.db.db_instance_port		
}


output "db_instance_name" {
  value = module.db.db_instance_name		
}
