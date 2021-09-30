#------------------------------------------------------------------------------------------------
#                                         VPC
#------------------------------------------------------------------------------------------------

//  All info about module you can find in https://github.com/terraform-aws-modules/terraform-aws-vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.environment}-vpc-for-${var.company_name}"
  cidr = var.cidr_block

  azs               = var.azs
  private_subnets   = var.private_subnets
  public_subnets    = var.public_subnets
  database_subnets  = var.database_subnets
  create_database_subnet_group = false
  create_database_subnet_route_table     = true
#  create_database_internet_gateway_route = true

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = var.common_tags
}