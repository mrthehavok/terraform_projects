

output "vpc_id" {
  value = module.vpc_dev.vpc_id	
}


output "vpc_cidr_block" {
  value = module.vpc_dev.vpc_cidr_block	
}


output "igw_id" {
  value = module.vpc_dev.igw_id	
}

output "subnet_id" {
  value = module.vpc_dev.public_subnets	
}

