#------------------------------------------------------------------------------------------------
#
#                                  Variables for VPC.
#
#------------------------------------------------------------------------------------------------
variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subnets" {
  default = ["10.0.1.0/24"]
}

variable "public_subnets" {
  default = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}


variable "database_subnets" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}


variable "environment" {
  default = "DEV"
}

variable "company_name" {
  default = "HashiCorp"
}


variable "common_tags" {
    default = {
                        Project     = "Alpha"
                        Created     = "By Terraform"
                        Owner       = "idmitriev"
                        Environment = "Development"
                        
    }
}
